import StatisticalSwift
import SwiftUI
import Charts
import StatKit

internal struct ContinuousUniformDistributionView: View {
  private var lower = 0.0
  @State
  private var upper = 1.0
  
  var body: some View {
    let distribution = ContinuousUniformDistribution(lower, upper)
    
    let data = stride(
      from: lower,
      through: upper,
      by: 0.01
    )
    .map { x in
      BarChartDataEntry(
        x: x,
        y: distribution.pdf(x: x)
      )
    }
    
    return VStack(spacing: 10) {
      LineChart(
        data: data,
        label: "Continuous Uniform Distribution (lower bound: \(String(format: "%.2f", lower)), upper bound: \(String(format: "%.2f", upper)))"
      )
      
      HStack(spacing: 20) {
        Slider(value: $upper, in: 1 ... 20) {
          Text("Range")
        }
        Spacer()
        Spacer()
          .frame(maxWidth: .infinity)
      }
    }
  }
}
