import StatisticalSwift

struct MovieWatcher {
  let id: Int
  let titles: [String]
  let ratings: [Double]
}

extension MovieWatcher: RowInitializable {
  init(headers: [String], line: [String]) throws {
    self.titles = Array(headers[1...])
    self.ratings = line[1...].compactMap(Double.init)
    
    guard
      let idString = line.first,
      let id = Int(idString),
      ratings.count == titles.count
    else {
      fatalError("Could not decode MovieWatcher type from CSV.")
    }
    self.id = id
  }
}
