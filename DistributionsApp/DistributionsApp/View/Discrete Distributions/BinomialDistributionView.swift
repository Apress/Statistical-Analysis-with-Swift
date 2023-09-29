import StatisticalSwift
import SwiftUI
import DGCharts
import StatKit

internal struct BinomialDistributionView: View {
  @State
  private var probability = 0.5
  @State
  private var trials = 5.0
  
  var body: some View {
    let distribution = BinomialDistribution(
      probability: probability,
      trials: Int(trials)
    )
    
    let data = stride(
      from: 0,
      through: Double(trials),
      by: 1
    )
    .map { x in
      BarChartDataEntry(
        x: x,
        y: distribution.pmf(x: Int(x))
      )
    }
    
    return VStack(spacing: 10) {
      Histogram(
        data: data,
        label: "Binomial Distribution (p: \(String(format: "%.2f", probability)), n: \(Int(trials)))"
      )
      
      HStack(spacing: 20) {
        Slider(value: $probability, in: 0.01 ... 0.99) {
          Text("Probability")
        }
        Spacer()
        Slider(value: $trials, in: 1 ... 20, step: 1) {
          Text("Trials")
        }
      }
    }
  }
}
