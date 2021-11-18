import StatKit

internal enum RandomVariables {
  static func run() {
    let die = Die()
    for _ in 1 ... 5 {
      let rolls = (1 ... 5)
        .map { _ in String(die.roll()) }
        .joined(separator: ", ")
      
      print("We rolled \(rolls)")
    }
  }
}

private struct Die {
  internal func roll() -> Int {
    return .random(in: 1 ... 6)
  }
}
