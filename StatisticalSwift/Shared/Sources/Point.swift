public struct Point: Decodable {
  public let x: Double
  public let y: Double
  
  public init(x: Double, y: Double) {
    self.x = x
    self.y = y
  }
}
