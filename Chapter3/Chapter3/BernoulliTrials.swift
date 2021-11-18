internal enum BernoulliTrials {
  private static func simulate(p: Double) {
    let q = (100 - p * 100).rounded() / 100
    
    let results = (1 ... 10000)
      .reduce(into: [0, 0]) { result, _ in
      let success = Double.random(in: 0 ... 1) < p
      result[success ? 1 : 0] += 1
    }
    .enumerated()
    .map { index, count -> String in
      let outcome = (index == 0) ? "Tails" : "Heads"
      let probability = (index == 0) ? q : p
      return "\(outcome) (\(probability)): \(count)"
    }
    
    print(
      """
      \(results.joined(separator: "\n"))
      
      """
    )
  }
  
  internal static func run() {
    simulate(p: 0.50)
    simulate(p: 0.54)
  }
}
