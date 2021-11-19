public struct Person: Decodable {
  public let name: String
  public let age: Int
  
  private enum CodingKeys: String, CodingKey {
    case name = "name"
    case age = "age"
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder
      .container(keyedBy: CodingKeys.self)
    
    self.name = try container
      .decode(String.self, forKey: .name)
    
    self.age = try container
      .decode(Int.self, forKey: .age)
  }
}
