import StatisticalSwift
import StatKit

struct HouseSale: Decodable {
  let size: Double
  let rooms: Double
  let fee: Double
  let elevator: Double
  let balcony: Double
  let patio: Double
  let price: Double
  
  enum CodingKeys: String, CodingKey {
    case size = "Size"
    case rooms = "Rooms"
    case fee = "Fee"
    case elevator = "Elevator"
    case balcony = "Balcony"
    case patio = "Patio"
    case price = "Price"
  }
}

internal enum HousePricePredictions {
  internal static func run() {
    let allHouseSales = DataLoader.load(HouseSale.self, from: .houseSaleData)
    
    let midPoint = allHouseSales.count / 2
    let trainingData = Array(allHouseSales[...midPoint])
    let testingData = Array(allHouseSales[midPoint...])
    
    // Play around with which data variables to take into account.
    // For this example, we use the Root Mean Squared Error (RMSE) to
    // measure how far off our predictions are.
    let regressor = try! MultipleLinearRegression(
      from: trainingData,
      data: \.size, \.rooms, \.patio, \.elevator, \.balcony, \.fee,
      target: \.price
    )
    
    // mean(of:) comes from the StatKit library. Similarly to
    // the other functionality we have developed, it works with
    // KeyPath's to determine the variable of interest.
    let meanSquaredError = testingData.lazy
      .map { sale in
        pow(regressor.predict(x: sale) - sale.price, 2)
      }
      .mean(of: \.self)
      .squareRoot()
    
    print(
      """
      The mean squared error of this setup is: \(meanSquaredError)
      """
    )
  }
}
