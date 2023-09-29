import StatisticalSwift
import SwiftUI
import DGCharts
import StatKit

internal struct DiscreteUniformDistributionView: View {
  private var lower = 0.0
  @State
  private var upper = 1.0
  
  var body: some View {
    let distribution = DiscreteUniformDistribution(Int(lower), Int(upper))
    
    let data = stride(
      from: lower,
      through: upper,
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
        label: "Discrete Uniform Distribution (lower bound: \(Int(lower)), upper bound: \(Int(upper)))"
      )
      
      HStack(spacing: 20) {
        Slider(value: $upper, in: 1 ... 20, step: 1) {
          Text("Range")
        }
        Spacer()
        Spacer()
          .frame(maxWidth: .infinity)
      }
    }
  }
}
