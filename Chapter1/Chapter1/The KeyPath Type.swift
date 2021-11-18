import Foundation
import StatisticalSwift
import StatKit

internal enum TheKeyPathType {
  static func run() {
    let people = DataLoader.load(
      Person.self,
      from: .people
    )
    
    print(
      """
      This prints the values associated with
      the KeyPath Person.name in a for-loop.
      
      """
    )
    
    let nameKey = \Person.name
    for person in people {
      let name = person[keyPath: nameKey]
      print("Name: \(name)")
    }
    
    
    let names = people
      .map(\.name)
      .joined(separator: " and ")
    
    let ages = people
      .map(\.age)
      .map(String.init)
      .joined(separator: " and ")
    
    let totalAge = people
      .sum(over: \.age)
    
    print(
      """
      
      
      These are the results of using KeyPaths in our 'map' and 'sum' methods.
      
      We have \(names) with us today!
      They are aged \(ages), respectively,
      totaling \(totalAge) years together!


      Below, we use PartialKeyPaths to print a random property from a random person.
      This type of dynamic behavior would not be possible without KeyPaths.
      
      """
    )
    
    let partialkeys: [PartialKeyPath<Person>] = [
      \Person.name,
      \Person.age
    ]
    
    for _ in 1 ... 5 {
      guard
        let randomKey = partialkeys.randomElement(),
        let person = people.randomElement()
      else { continue }
      
      let value = person[keyPath: randomKey]
      print(value)
    }
    
  }
}
