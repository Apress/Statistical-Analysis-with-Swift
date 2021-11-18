import Foundation
import StatKit

internal enum ComputingPValues {
  private enum TestTail {
    case left
    case right
    case both
  }
  
  private static func pValue(
    of x: Double,
    mu: Double,
    sigma: Double,
    tail: TestTail
  ) -> Double {
    
    let dist = NormalDistribution(
      mean: mu,
      standardDeviation: sigma
    )
    let leftProb = dist.cdf(x: mu - abs(mu - x))
    
    return tail == .both
      ? 2 * leftProb
      : leftProb
  }
  
  internal static func run() {
    let sample = 105.0
    let mu = 100.0
    let sigma = 15 / sqrt(30)
    let pValue = pValue(
      of: sample,
      mu: mu,
      sigma: sigma,
      tail: .right
    )

    print(
      """
      P-Value for the dean's experiment:
      \(pValue)
      """
    )
  }
}
