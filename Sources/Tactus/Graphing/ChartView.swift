import SwiftUI
import Charts
import GameplayKit
import SwiftSplines

typealias Function = @Sendable (Double) -> Double

enum Values {
    static let xScale = 0.0...10.0
    static let yScale = -1.2...1.2
}

struct PlotData: Identifiable, Comparable {
    let id: Int
    let x: Double
    let y: Double
    /// compare on y value
    static func < (lhs: PlotData, rhs: PlotData) -> Bool {
        lhs.y < rhs.y
    }
}

struct ContentView: View {
    @State var slider: Double = 1
    @ObservedObject var presenter = ChartPresenter()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                charts
            }
            .padding()
        }
    }
    
    @ViewBuilder
    var charts: some View {
        Text("Pure Function - _with noisy 'hand drawn' points_")
            .font(.headline)
        let noisyData = presenter.noisyData
        let extremities = noisyData.extremities()
        Chart {
            Plot {
                LinePlot(x: "x", y: "y") { [f = presenter.function] x in f(x) }
                .foregroundStyle(.blue)
                .lineStyle(.init(lineWidth: 3, lineCap: .round, lineJoin: .round))
            }
            ForEach(noisyData) {
                PointMark(x: .value("x", $0.x), y: .value("y", $0.y))
                    .foregroundStyle(.red)

            }
        }
        .modifier(ChartStyle())

        
        Text("Spline Curves - _using local minima / maxima as control points_")
            .font(.headline)
        Chart {
            ForEach(extremities.splinedData(range: Values.xScale, steps: 1000)) {
                LineMark(x: .value("x", $0.x), y: .value("y", $0.y))
                    .lineStyle(.init(lineWidth: 3, lineCap: .round, lineJoin: .round))
            }
            ForEach(extremities) {
                PointMark(x: .value("x", $0.x), y: .value("y", $0.y))
                    .foregroundStyle(.green)
            }
        }
        .foregroundStyle(.green)
        .modifier(ChartStyle())
    }
}

struct ChartStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .chartXScale(domain: Values.xScale)
            .chartYScale(domain: Values.yScale)
            .frame(height: 200)
    }
}

class ChartPresenter: ObservableObject {
    @Published var function: Function = { x in
        cos(x/2) * sin(x*2)
    }
    
    @Published var noisyData: [PlotData] = []
    
    init() {
        self.noisyData = jitteredPoints(with: function, range: Values.xScale, steps: 50)
    }
    
    private let gaussian = GKGaussianDistribution(
        randomSource: GKRandomSource(),
        mean: 0,
        deviation: 5
    )
    
    func jitteredPoints(
        with function: @escaping Function,
        range: ClosedRange<Double>,
        steps: Int
    )  -> [PlotData] {
        // compute array of x values for each step across range
        let xValues: [Double] = Array(stride(
            from: range.lowerBound,
            through: range.upperBound,
            by: range.length / Double(steps)
        ))
        
        // generate plotData via f(x)
        return xValues.enumerated().map { i, x in
            let xJitter = Double(gaussian.nextUniform()) * 0.15
            let yJitter = Double(gaussian.nextUniform()) * 0.15
            let x = xValues[i]
            let y = function(x)
            return PlotData(id: i, x: x + xJitter, y: y + yJitter)
        }
    }
    
}

extension [PlotData] {
    /// Converts the given `[PlotData]` to an array of the local minima & maxima, aka 'extremities'.
    /// **Note that first and last values are always considered extremities.**
    func extremities() -> [PlotData] {
        let lastIndex = count - 1
        var indexes: [Int] = []
        indexes.append(0)
        for i in 1..<(lastIndex) {
            
            let isMinima = (self[i - 1] > self[i]) && (self[i] < self[i + 1])
            let isMaxima = !isMinima && (self[i - 1] < self[i]) && (self[i] > self[i + 1])
            
            if isMinima || isMaxima {
                indexes.append(i)
            }
        }
        indexes.append(lastIndex)
        return indexes.map { self[$0] }
    }
    
    // TODO: description for this:
    func splinedData(range: ClosedRange<Double>, steps: Int) -> [PlotData] {
        let spline = Spline(
            arguments: map(\.x),
            values: map(\.y),
            boundaryCondition: .smooth)
        
        let xValues: [Double] = Array<Double>(stride(
            from: range.lowerBound,
            through: range.upperBound,
            by: range.length / Double(steps)
        ))
        
        return xValues.enumerated().map { i, x in
            PlotData(id: i, x: x, y: spline.f(t: x))
        }
    }
}

extension ClosedRange where Bound == Double {
    var length: Double {
        sqrt((upperBound - lowerBound)**2)
    }
    
}

#Preview {
    ContentView()
}
