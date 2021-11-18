import Darwin

internal enum ExponentialDistributionProbabilities {
  private static func probability(
    between x: Double,
    and y: Double,
    rate: Double
  ) {
    
    precondition(0 <= x, "x mustbe non-negative.")
    precondition(0 <= y, "y must be non-negative.")
    precondition(x <= y, "x must be ≤ y.")
    precondition(0 < rate, "rate must be positive.")
    
    let upperCDF = 1 - exp(-rate * y)
    let lowerCDF = 1 - exp(-rate * x)
    let prob = upperCDF - lowerCDF
    
    print(
      """
      P[\(x) ≤ x ≤ \(y) | λ = \(rate)] = \(prob)
      """
    )
  }
  
  internal static func run() {
    probability(between: 0, and: 1, rate: 2)
    probability(between: 0, and: 1, rate: 0.2)
    probability(between: 0, and: 0, rate: 10)
  }
}

