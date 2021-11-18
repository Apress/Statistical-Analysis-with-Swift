import StatisticalSwift
import StatKit

internal enum SimpleLinearRegressionExample {
  internal static func run() {
    let points = DataLoader.load(
      Point.self,
      from: .simpleLinearRegression
    )
    let regressor = SimpleLinearRegression(
      from: points,
      x: \.x,
      y: \.y
    )
    
    let x = 5.0
    let prediction = regressor.predict(x: x)
    let observed = points
      .first(where: { point in
        point.x == 5
      })!.y
    
    print(
      """
      Best fit linear equation for example data
      f(x) = \(regressor)
      Prediction for x = 5
      \(prediction)
      Observed value for x = 5
      \(observed)
      """
    )
  }
}
