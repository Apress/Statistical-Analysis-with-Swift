import Foundation
import StatKit

internal enum BinomialDistributionPMF {
  private static func binomialPMF(
    of x: Int,
    p: Double,
    n: Int
  ) -> Double {
    precondition(0 < x, "0 ≮ x.")
    precondition(0 < p && p <= 1, "p ∉ (0, 1].")
    precondition(0 < n, "n must be positive.")
    
    let binomialCoef = choose(n: n, k: x).realValue
    let successProb = pow(p, x.realValue)
    let failureProb = pow(1 - p, (n - x).realValue)
    return binomialCoef * successProb * failureProb
  }
  
  internal static func run() {
    let p = 0.4
    let n = 10
    let x = 7

    let pmf = binomialPMF(of: x, p: p, n: n)
    let probability = String(format: "%.2f", p)

    print(
      """
      Likelihood of \(x) heads,
      with p = \(probability) and n = \(n):
      \(String(format: "%.4f", pmf))
      """
    )
  }
}
