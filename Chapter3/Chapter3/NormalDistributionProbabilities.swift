import Darwin

internal enum NormalDistributionProbabilities {
  private static let p = 0.3275911
  private static let coefficients = [
    0.254829592,
    -0.284496736,
    1.421413741,
    -1.453152027,
    1.061405429
  ]
  
  private static let exponents = (1 ... coefficients.count)
    .map(Double.init)
  
  private static func erf(_ z: Double) -> Double {
    let sign = (z.sign == .plus) ? 1.0 : -1.0
    let absZ = abs(z)
    let t = 1 / (1 + p * absZ)
    
    let powerSeries = zip(coefficients, exponents)
      .reduce(into: 0.0) { (result, zipped) in
        let (coefficient, exponent) = zipped
        result += coefficient * pow(t, exponent)
      }
    
    let tail = powerSeries * exp(-pow(absZ, 2))
    return sign * (1 - tail)
  }
  
  private static func normalCDF(x: Double, mu: Double, sigma: Double) {
    let z = (x - mu) / (sigma * sqrt(2))
    let prob = 0.5 * (1 + erf(z))
    
    print(
      """
      P[X < \(x) | μ = \(mu), σ = \(sigma)] = \(prob)
      """
    )
  }
  
  internal static func run() {
    normalCDF(x: 0, mu: 0, sigma: 1)
    normalCDF(x: -1, mu: 2, sigma: 4)
  }
}

