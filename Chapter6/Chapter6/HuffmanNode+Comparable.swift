extension HuffmanNode: Comparable {
  static func < (
    lhs: HuffmanNode<Value>,
    rhs: HuffmanNode<Value>
  ) -> Bool {
    
    switch (lhs, rhs) {
      case (.leaf(let lhsValue, let lhsCount),
            .leaf(let rhsValue, let rhsCount)):
        
        return lhsCount == rhsCount
          ? lhsValue < rhsValue
          : lhsCount < rhsCount
        
      default:
        return lhs.count < rhs.count
    }
  }
  
  static func == (
    lhs: HuffmanNode<Value>,
    rhs: HuffmanNode<Value>
  ) -> Bool {
    
    switch (lhs, rhs) {
      case (.node(let lhsleft, let lhsright),
            .node(let rhsleft, let rhsright)):
        
        return
          lhsleft == rhsleft &&
          lhsright == rhsright
        
      case (.leaf(let lhsValue, let lhsCount),
            .leaf(let rhsValue, let rhsCount)):
        
        return
          lhsValue == rhsValue &&
          lhsCount == rhsCount
        
      default:
        return false
    }
  }
}
