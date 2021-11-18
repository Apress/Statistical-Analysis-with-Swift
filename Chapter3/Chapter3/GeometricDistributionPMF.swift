import Foundation

internal enum GeometricDistributionPMF {
  private static func geometricPMF(
    of x: Int,
    with p: Double
  ) -> Double {
    precondition(0 < x, "0 ≮ x.")
    precondition(0 < p && p <= 1, "p ∉ (0, 1].")
    return p * pow(1 - p, Double(x) - 1)
  }
  
  internal static func run() {
    let probability = 0.4
    
    (1 ... 8)
      .reduce(into: [Int: Double]()) { result, x in
        result[x] = geometricPMF(of: x, with: probability)
      }
      .sorted(by: <)
      .forEach { trials, prob in
        let probability = String(format: "%.4f", prob)
        print("\(trials): \(probability)")
      }
  }
}
