import StatisticalSwift
import SwiftUI

struct DistributionsView: View {
  @State
  private var selectedType = DistributionType.discrete
  @State
  private var selectedDiscrete = DiscreteDistribution.binomial
  @State
  private var selectedContinuous = ContinuousDistribution.exponential
  
  var body: some View {
    VStack(spacing: 20) {
      Text("Distributions")
        .font(.title)
      
      HStack(spacing: 10) {
        VStack {
          Text("Select a distribution type")
            .font(.subheadline)
          
          DistributionPicker(selection: $selectedType)
            .pickerStyle(SegmentedPickerStyle())
        }
        
        VStack {
          Text("Select a distribution")
            .font(.subheadline)
          
          if selectedType == .discrete {
            DistributionPicker(selection: $selectedDiscrete)
              .pickerStyle(PopUpButtonPickerStyle())
          } else if selectedType == .continuous {
            DistributionPicker(selection: $selectedContinuous)
              .pickerStyle(PopUpButtonPickerStyle())
          }
        }
      }
      
      if selectedType == .discrete {
        DiscreteDistributionView(selected: $selectedDiscrete)
      } else if selectedType == .continuous {
        ContinuousDistributionView(selected: $selectedContinuous)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding()
  }
}

struct DistributionsView_Previews: PreviewProvider {
  static var previews: some View {
    DistributionsView()
  }
}
