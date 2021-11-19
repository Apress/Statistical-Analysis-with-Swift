public struct Point3D: Decodable {
  public let x: Double
  public let y: Double
  public let z: Double
  
  public init(x: Double, y: Double, z: Double) {
    self.x = x
    self.y = y
    self.z = z
  }
}
