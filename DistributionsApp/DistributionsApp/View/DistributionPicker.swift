import StatisticalSwift
import SwiftUI

typealias DistributionID = CaseIterable & RawRepresentable & Identifiable & Hashable

struct DistributionPicker<Type: DistributionID>: View where Type.RawValue == String, Type.AllCases == [Type] {
  @Binding
  var selection: Type
  
  var body: some View {
    Picker("", selection: $selection) {
      ForEach(Type.allCases) { distribution in
        Text(distribution.rawValue.capitalized)
          .tag(distribution)
      }
    }
  }
}
