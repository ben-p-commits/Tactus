import SwiftUI
import Charts


struct ContentView: View {
    @State var slider: Double = 1
    @ObservedObject var presenter = ChartPresenter()
    
    var body: some View {
        ScrollView {
            VStack {
                chart
                    .padding()
                    .padding(.top, 100)
            }
        }
    }
    
    var chart: some View {
        Chart {
            LinePlot(x: "x", y: "y") { [f = presenter.function] x in
                f(x)
            }
        }
        .chartXScale(domain: -0...4)
        .frame(width: 1200, height: 620)
    }
}

class ChartPresenter: ObservableObject {
    typealias Function = @Sendable (Double) -> Double
    
    
    
    @Published var function: Function = { x in
        sin(-3 * pow(x, 2))
    }
    
    func calculateRiemannSumDataFor(
        _ function: @escaping Function,
        from start: Double,
        to end: Double,
        divisionWidth: Int
    )  {
        
    }
}

#Preview {
    ContentView()
}
