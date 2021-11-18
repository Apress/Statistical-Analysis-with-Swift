import Foundation
import StatisticalSwift
import CodableCSV

public enum TheCodableProtocol {
  static func run() {
    let decoder = CSVDecoder { config in
      config.headerStrategy = .firstLine
    }
    
    guard
      let csvURL = Bundle(identifier: "se.applyn.StatisticalSwift")?
        .url(forResource: "people", withExtension: "csv"),
      let peopleData = try? Data(contentsOf: csvURL),
      let people = try? decoder
        .decode([Person].self, from: peopleData)
    else {
      fatalError(
        """
        Could not find people.csv.
        Check that it is available in the Statistical Swift Shared Data folder.
        """
      )
    }
    
    for person in people {
      print(person)
    }
  }
}
