import StatisticalSwift
import SwiftUI

struct ContinuousDistributionView: View {
  @Binding
  var selected: ContinuousDistribution
  
  var body: some View {
    VStack(spacing: 20) {
      if selected == .exponential {
        ExponentialDistributionView()
      } else if selected == .normal {
        NormalDistributionView()
      } else if selected == .uniform {
        ContinuousUniformDistributionView()
      }
    }
    
  }
}
