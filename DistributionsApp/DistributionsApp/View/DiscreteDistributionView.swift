import StatisticalSwift
import SwiftUI

struct DiscreteDistributionView: View {
  @Binding
  var selected: DiscreteDistribution
  
  var body: some View {
    VStack(spacing: 20) {
      if selected == .binomial {
        BinomialDistributionView()
      } else if selected == .poisson {
        PoissonDistributionView()
      } else if selected == .uniform {
        DiscreteUniformDistributionView()
      }
    }
    
  }
}
