import SwiftUI

internal enum DistributionType: String, Identifiable, CaseIterable {
  case discrete
  case continuous
  
  var id: Self.RawValue { self.rawValue }
}

internal enum DiscreteDistribution: String, Identifiable, CaseIterable {
  case binomial
  case poisson
  case uniform
  
  var id: Self.RawValue { self.rawValue }
}

internal enum ContinuousDistribution: String, Identifiable, CaseIterable {
  case exponential
  case normal
  case uniform
  
  var id: Self.RawValue { self.rawValue }
}
