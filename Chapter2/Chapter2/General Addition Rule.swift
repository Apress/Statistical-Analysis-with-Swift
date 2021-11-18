internal enum GeneralAdditionRule {
  private static let dieRolls = Array(1 ... 6)
  
  internal static func run() {
    let totalCount = Double(dieRolls.count)
    let E1 = { (roll: Int) -> Bool in
      return roll == 1
    }

    let E2 = { (roll: Int) -> Bool in
      return roll == 2
    }

    let mutExUnionProb = Double(
      dieRolls.filter { roll in
        E1(roll) || E2(roll)
      }.count
    ) / totalCount

    let E1Prob = Double(
      dieRolls.filter(E1).count
    ) / totalCount

    let E2Prob = Double(
      dieRolls.filter(E1).count
    ) / totalCount

    print(
      """
      Mutually Exclusive events E1 and E2:
      
      P[E1 || E2]:   \(mutExUnionProb)
      P[E1]:         \(E1Prob)
      P[E2]:         \(E2Prob)
      P[E1] + P[E2]: \(E1Prob + E2Prob)
      
      """
    )


    let E3 = { (roll: Int) -> Bool in
      return roll.isMultiple(of: 2)
    }

    let nonMutExUnionProb = Double(
      dieRolls.filter { roll in
        E2(roll) || E3(roll)
      }.count) / totalCount

    let E3Prob = Double(
      dieRolls.filter(E3).count
    ) / totalCount

    let E2andE3 = Double(
      dieRolls.filter { roll in
        E2(roll) && E3(roll)
      }.count) / totalCount
    
    let genAddRule = E2Prob + E3Prob - E2andE3
    
    print(
      """
      Events E2 and E3, no mutual exclusivity:
      
      P[E2 || E3]:   \(nonMutExUnionProb)
      P[E2]:         \(E2Prob)
      P[E3]:         \(E3Prob)
      P[E2] + P[E3]: \(E2Prob + E3Prob)
      
      General Addition Rule
      P[E2] + P[E3] - P[E2 && E3]: \(genAddRule)
      """
    )
  }
}
