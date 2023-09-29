import StatisticalSwift
import SwiftUI
import DGCharts
import StatKit

internal struct ExponentialDistributionView: View {
  @State
  private var rate = 0.5
  
  var body: some View {
    let distribution = ExponentialDistribution(rate: rate)
    
    let data = stride(
      from: 0,
      through: 20,
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
        label: "Exponential Distribution (rate: \(String(format: "%.2f", rate)))"
      )
      
      HStack(spacing: 20) {
        Slider(value: $rate, in: 0.01 ... 2.0) {
          Text("Rate")
        }
        Spacer()
        Spacer()
          .frame(maxWidth: .infinity)
      }
    }
  }
}
