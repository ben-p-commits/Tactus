import SwiftUI
import Charts
import GameplayKit

typealias Function = @Sendable (Double) -> Double

struct ContentView: View {
    @State var slider: Double = 1
    @ObservedObject var presenter = ChartPresenter()
    
    var body: some View {
        VStack {
            Spacer()
            chart
                .padding()
            Spacer()
        }
    }
    
    var chart: some View {
        Group {
            let data = presenter.jitteredPoints(
                with: presenter.function,
                from: 0,
                to: 10,
                steps: 50
            )
            Chart(data) {
                PointMark(x: .value("x", $0.x), y: .value("y", $0.y))
                    .foregroundStyle(.red)
            }
            Chart {
                Plot {
                    LinePlot(x: "x", y: "y") { [f = presenter.function] x in
                        f(x)
                    }
                    .foregroundStyle(.blue)
                    .lineStyle(.init(lineWidth: 3, lineCap: .round, lineJoin: .round))
                }
            }
        }
        .padding(32)
        .chartXScale(domain: 0...10)
        .frame(height: 400)
        .background(
            Color(UIColor.secondarySystemBackground)
                .cornerRadius(8)
        )
        
    }
}

struct PlotData: Identifiable {
    let id: Int
    let x: Double
    let y: Double
}

class ChartPresenter: ObservableObject {
    @Published var function: Function = { x in
        cos(x/2) * sin(x*2)
    }
    private let gaussian = GKGaussianDistribution(
        randomSource: GKRandomSource(),
        mean: 0,
        deviation: 5
    )
    
    func jitteredPoints(
        with function: @escaping Function,
        from start: Double,
        to end: Double,
        steps: Int
    )  -> [PlotData] {
        
        // get the length of the x axis
        let xAxisLength = sqrt((end - start)**2)
        
        // get bar width (step size)
        let stepSize = xAxisLength / Double(steps)
        
        // compute array of x values for each step across range
        let xValues: [Double] = Array(stride(from: start, through: end, by: stepSize))
        
        // generate plotData via f(x)
        return xValues.enumerated().map { i, x in
            let xJitter = Double(gaussian.nextUniform()) * 0.2
            let yJitter = Double(gaussian.nextUniform()) * 0.2
            let x = xValues[i]
            let y = function(x)
            return PlotData(id: i, x: x + xJitter, y: y + yJitter)
        }
    }
}

#Preview {
    ContentView()
}
