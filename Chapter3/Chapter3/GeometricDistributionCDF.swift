import Foundation

internal enum GeometricDistributionCDF {
  private static func geometricPMF(
    of x: Int,
    with p: Double
  ) -> Double {
    
    precondition(0 < x, "0 ≮ x.")
    precondition(0 < p && p <= 1, "p ∉ (0, 1].")
    return p * pow(1 - p, Double(x) - 1)
  }
  
  internal static func run() {
    let probability = 0.25
    
    let cdf = (1 ... 5)
      .reduce(into: 0.0) { result, x in
        result += geometricPMF(of: x, with: probability)
      }
    
    print("P[X ≤ 5] = \(cdf)")
  }
}
