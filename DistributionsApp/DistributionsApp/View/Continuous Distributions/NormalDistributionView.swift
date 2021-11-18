import StatisticalSwift
import SwiftUI
import Charts
import StatKit

internal struct NormalDistributionView: View {
  @State
  private var mean = 0.0
  @State
  var variance = 1.0
  
  var body: some View {
    let distribution = NormalDistribution(mean: mean, variance: variance)
    
    let data = stride(
      from: -6,
      through: 6,
      by: 0.01
    )
    .map { x in
      ChartDataEntry(
        x: x,
        y: distribution.pdf(x: x)
      )
    }
    
    return VStack(spacing: 10) {
      LineChart(
        data: data,
        label: "Normal Distribution (mean: \(String(format: "%.2f", mean)), variance: \(String(format: "%.2f", variance)))"
      )
      
      HStack(spacing: 20) {
        Slider(value: $mean, in: -4 ... 4) {
          Text("Mean")
        }
        Spacer()
        Slider(value: $variance, in: 0.01 ... 4) {
          Text("Variance")
        }
      }
    }
  }
}
