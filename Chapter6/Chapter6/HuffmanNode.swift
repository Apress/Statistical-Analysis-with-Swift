import Foundation

indirect enum HuffmanNode<Value>
where Value: Hashable & Comparable {
  case node(left: HuffmanNode, right: HuffmanNode)
  case leaf(value: Value, count: Int)
  
  var count: Int {
    switch self {
      case .leaf(_, let count):
        return count
        
      case .node(let lhs, let rhs):
        return lhs.count + rhs.count
    }
  }
  
  func codeMap() -> [Value: (data: Data, bitLength: Int)] {
    switch self {
      case .leaf(let value, _):
        return [value: (Data([0x80]), 1)]
        
      case .node(let left, let right):
        var dict = [Value: (data: Data, bitLength: Int)]()
        
        left.codeMap(dict: &dict, level: 1, path: Data([0]))
        right.codeMap(dict: &dict, level: 1, path: Data([0x80]))
        return dict
    }
  }
  
  private func codeMap(
    dict: inout [Value: (data: Data, bitLength: Int)],
    level: Int,
    path: Data
  ) {
    switch self {
      case .leaf(let value, _):
        dict[value] = (path, level)
        
      case .node(let left, let right):
        var leftPath = path
        if level.isMultiple(of: 8) { leftPath.append(0) }
        left.codeMap(
          dict: &dict,
          level: level + 1,
          path: leftPath
        )
        
        var rightPath = path
        if level.isMultiple(of: 8) { rightPath.append(0) }
        rightPath[level / 8] |= 0x80 >> (level % 8)
        right.codeMap(
          dict: &dict,
          level: level + 1,
          path: rightPath
        )
    }
  }
}
