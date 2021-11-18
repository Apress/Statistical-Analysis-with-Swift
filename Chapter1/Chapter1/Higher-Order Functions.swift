import CoreGraphics

internal extension MutableCollection {
  mutating func apply<T>(
    to key: WritableKeyPath<Element, T>,
    _ transform: (T) -> T
  ) {
    for index in self.indices {
      let newValue = transform(
        self[index][keyPath: key]
      )
      self[index][keyPath: key] = newValue
    }
  }
}

internal enum HigherOrderFunctions {
  internal static func run() {
    var points = [
      CGPoint(x: 1, y: 1),
      CGPoint(x: 2, y: 2),
      CGPoint(x: 3, y: 3)
    ]

    print("Before: \(points)")
    points.apply(to: \.y) { value in
      value * value
    }
    print("After:  \(points)", terminator: "\n\n")
    
    var values = [1, -5, -2, 4, -1, 3]
    print("Before: \(values)")
    values.apply(to: \.self, Swift.abs)
    print("After:  \(values)", terminator: "\n\n")
  }
}
