import StatKit

internal enum ConditionalProbabilities {
  private static let dieRolls = Array(1 ... 6)
  private static let evenRolls = [2, 4, 6]
  private static let oddRolls = [1, 3, 5]
  
  internal static func run() {
    let firstIs1Prob = dieRolls.filter { roll in
      roll == 1
    }.count.realValue / dieRolls.count.realValue

    let secondIs2Prob = oddRolls.filter { roll in
      roll == 2
    }.count.realValue / oddRolls.count.realValue

    let rollIs4GivenEvenProb = dieRolls.filter { roll in
      roll == 4
    }.count.realValue / evenRolls.count.realValue

    let rollIsEven = dieRolls.filter { roll in
      roll.isMultiple(of: 2)
    }.count.realValue / dieRolls.count.realValue

    print(
      """
      P[roll2 == 2 | roll1 == 1] * P[roll1 == 1]:
      \(secondIs2Prob * firstIs1Prob)
      
      P[roll1 == 4 | roll1 == even] * P[roll1 == even]:
      \(rollIs4GivenEvenProb * rollIsEven)
      """
    )
  }
}
