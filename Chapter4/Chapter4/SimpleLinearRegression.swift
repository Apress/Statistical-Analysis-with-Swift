import StatKit

internal struct SimpleLinearRegression
<Element, X: ConvertibleToReal, Y: ConvertibleToReal>
: CustomStringConvertible {
  internal let k: Double
  internal let m: Double
  
  internal var description: String {
    let sign = (m.sign == .plus) ? "+" : "-"
    return "\(k)x \(sign) \(abs(m))"
  }
  
  internal init(
    from samples: [Element],
    x: KeyPath<Element, X>,
    y: KeyPath<Element, Y>
  ) {
    let n = samples.count.realValue
    
    let (xSum, ySum, xSqSum, xySum) = samples
      .reduce(
        into: (0.0, 0.0, 0.0, 0.0)
      ) { result, point in
        let x = point[keyPath: x].realValue
        let y = point[keyPath: y].realValue
        result.0 += x
        result.1 += y
        result.2 += x * x
        result.3 += x * y
      }
    
    let kNumerator = (n * xySum - xSum * ySum)
    let kDenominator = (n * xSqSum - xSum * xSum)
    self.k = kNumerator / kDenominator
    self.m = (ySum - k * xSum) / n
  }
  
  internal func predict(x: X) -> Double {
    return k * x.realValue + m
  }
}
