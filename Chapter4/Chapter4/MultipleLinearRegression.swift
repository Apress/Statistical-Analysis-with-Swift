import StatKit
#if os(Linux)
import Glibc
#else
import Accelerate
#endif

internal struct MultipleLinearRegression
<Element, X: ConvertibleToReal, Y: ConvertibleToReal>
: CustomStringConvertible {
  internal let w: [Double]
  internal let variables: [KeyPath<Element, X>]
  
  internal var description: String {
    w.enumerated().map { index, weight -> String in
      let positive = weight.sign == .plus
      let variableName = index != (w.count - 1) ? " * x_\(index + 1)" : ""
      var sign = ""
      
      switch (positive, index != .zero) {
        case (true, true):
          sign = " + "
        case (false, _):
          sign = " - "
        default:
          break
      }
      
      return "\(sign)\(abs(weight))\(variableName)"
    }
    .joined()
  }
  
  internal init(
    from samples: [Element],
    data: KeyPath<Element, X>...,
    target: KeyPath<Element, Y>
  ) throws {
    let sampleCount = Int32(samples.count)
    let dimCount32 = Int32(data.count + 1)
    let dimCount64 = data.count + 1
    let XTransXDimension = dimCount64 * dimCount64

    var X = samples.flatMap { sample -> [Double] in
      var row = data.map { keyPath in
        sample[keyPath: keyPath].realValue
      }
      
      row.append(1)
      return row
    }

    var XTrans = X

    var Y = samples.map { sample in
      return sample[keyPath: target].realValue
    }

    var XTransX = [Double](
      repeating: 0,
      count: XTransXDimension
    )
    var XTransY = [Double](
      repeating: 0,
      count: dimCount64
    )
    
    cblas_dgemv(
      CblasRowMajor,
      CblasTrans,
      sampleCount,
      dimCount32,
      1,
      &XTrans,
      dimCount32,
      &Y,
      1,
      1,
      &XTransY,
      1
    )
    
    cblas_dgemm(
      CblasRowMajor,
      CblasTrans,
      CblasNoTrans,
      dimCount32,
      dimCount32,
      sampleCount,
      1,
      &XTrans,
      dimCount32,
      &X,
      dimCount32,
      1,
      &XTransX,
      dimCount32
    )
    
    var m = dimCount32
    var n = m
    var lda = m
    var workspaceSize = 100 * m
    
    var pivots = [Int32](
      repeating: 0,
      count: dimCount64
    )
    var workspace = [Double](
      repeating: 0,
      count: Int(workspaceSize)
    )
    var luError = Int32.zero
    var invError = Int32.zero
    
    dgetrf_(&m, &n, &XTransX, &lda, &pivots, &luError)
    
    switch luError {
      case ..<0:
        throw LinearRegressionError.invalidArguments
      case 1...:
        throw LinearRegressionError.singularMatrix
      default:
        break
    }
    
    dgetri_(&m, &XTransX, &lda, &pivots, &workspace, &workspaceSize, &invError)
    
    switch invError {
      case ..<0:
        throw LinearRegressionError.invalidArguments
      case 1...:
        throw LinearRegressionError.singularMatrix
      default:
        break
    }
    
    var w = [Double](repeating: 0, count: dimCount64)

    cblas_dgemv(
      CblasRowMajor,
      CblasTrans,
      dimCount32,
      dimCount32,
      1,
      &XTransX,
      dimCount32,
      &XTransY,
      1,
      1,
      &w,
      1
    )

    self.w = w
    self.variables = data
  }
  
  internal func predict(x: Element) -> Double {
    var features = variables.map { keyPath in
      x[keyPath: keyPath].realValue
    }
    
    features.append(1)
    let n = Int32(w.count)
    var w = w
    
    return cblas_ddot(
      n,
      &w,
      1,
      &features,
      1
    )
  }
  
  public enum LinearRegressionError: Error {
    case singularMatrix
    case invalidArguments
  }
}
