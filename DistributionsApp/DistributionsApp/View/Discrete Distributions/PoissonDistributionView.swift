import StatisticalSwift
import SwiftUI
import DGCharts
import StatKit

internal struct PoissonDistributionView: View {
  @State
  private var rate = 0.5
  
  var body: some View {
    let distribution = PoissonDistribution(rate: rate)
    
    let data = stride(
      from: 0,
      through: 20,
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
        label: "Poisson Distribution (rate: \(String(format: "%.2f", rate)))"
      )
      
      HStack(spacing: 20) {
        Slider(value: $rate, in: 0.01 ... 8) {
          Text("Rate")
        }
        Spacer()
        Spacer()
          .frame(maxWidth: .infinity)
      }
    }
  }
}
