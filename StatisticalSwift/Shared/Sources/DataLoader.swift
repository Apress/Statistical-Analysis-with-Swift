import Foundation
import CodableCSV

public enum DataLoader {
  public enum CustomSet: String {
    case movieRatings = "movie-ratings"
  }
  
  public enum DataSet: String {
    case people = "people"
    case simpleLinearRegression = "simple-linear-regression"
    case multipleLinearRegression = "multiple-linear-regression"
    case houseSaleData = "house-sale-data"
  }
  
  public enum TextSet: String {
    case huffman = "huffman-compression"
  }
  
  public static func load<Content: Decodable>(_ type: Content.Type, from dataset: DataSet) -> [Content] {
    let decoder = CSVDecoder {
      $0.headerStrategy = .firstLine
    }
    
    guard
      let bundle = Bundle(identifier: "se.applyn.StatisticalSwift"),
      let csvURL = bundle.url(forResource: dataset.rawValue, withExtension: "csv"),
      let data = try? Data(contentsOf: csvURL),
      let content = try? decoder.decode([Content].self, from: data)
    else {
      fatalError(
        """
        Could not find \(dataset.rawValue).csv!
        Check that it is available in the Data folder.
        """
      )
    }
    
    return content
  }
  
  public static func load<Content: RowInitializable>(_ type: Content.Type, from dataset: CustomSet) -> [Content] {
    var config = CSVReader.Configuration()
    config.headerStrategy = .firstLine
    
    guard
      let bundle = Bundle(identifier: "se.applyn.StatisticalSwift"),
      let csvURL = bundle.url(forResource: dataset.rawValue, withExtension: "csv"),
      let reader = try? CSVReader(input: csvURL, configuration: config)
    else {
      fatalError(
        """
        Could not find \(dataset.rawValue).csv!
        Check that it is available in the Data folder.
        """
      )
    }
    
    let headers = reader.headers
    var contents = [Content]()
    
    while
      let row = try? reader.readRow(),
      let instance = try? Content(headers: headers, line: row)
    {
      contents.append(instance)
    }
    
    return contents
  }
  
  public static func loadText(from dataset: TextSet) -> String {
    guard
      let bundle = Bundle(identifier: "se.applyn.StatisticalSwift"),
      let txtURL = bundle.url(forResource: dataset.rawValue, withExtension: "txt"),
      let text = try? String(contentsOf: txtURL, encoding: .utf8)
    else {
      fatalError(
        """
        Could not find \(dataset.rawValue).txt!
        Check that it is available in the Data folder.
        """
      )
    }
    
    return text
  }
}

public protocol RowInitializable {
  init(headers: [String], line: [String]) throws
}
