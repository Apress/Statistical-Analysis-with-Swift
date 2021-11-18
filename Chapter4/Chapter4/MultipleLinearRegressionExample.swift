import StatisticalSwift
import StatKit

internal enum MultipleLinearRegressionExample {
  internal static func run() {
    let points = DataLoader.load(
      Point3D.self,
      from: .multipleLinearRegression
    )
    
    do {
      let regressor = try MultipleLinearRegression(
        from: points,
        data: \.x, \.y,
        target: \.z
      )
      
      let observed = points[42]
      let prediction = regressor.predict(x: observed)
      
      print(
        """
        Best fit linear equation for example data
        f(x) = \(regressor)
        
        Prediction for (\(observed.x), \(observed.y))
        \(prediction)
        
        Observed value for (\(observed.x), \(observed.y))
        \(observed.z)
        """
      )
    }
    catch {
      print("An error was thrown: \(error)")
    }
  }
}
