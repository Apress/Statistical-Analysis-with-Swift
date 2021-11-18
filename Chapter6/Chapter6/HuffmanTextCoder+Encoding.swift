import Foundation.NSData

extension HuffmanTextCoder {
  func countBytes(in text: String) -> [UInt8: Int] {
    var text = text
    
    return text.withUTF8 { pointer in
      pointer
        .reduce(into: [UInt8: Int]()) { dict, byte in
          dict[byte, default: 0] += 1
        }
    }
  }
  
  func createHuffmanTree(from freqs: [UInt8: Int]) throws -> HuffmanNode<UInt8> {
    var nodes = freqs
      .map { key, value -> HuffmanNode in
        .leaf(value: key, count: value)
      }
      .sorted(by: >)
    
    guard !nodes.isEmpty else {
      throw HuffmanError.emptyInputData
    }
    
    while
      nodes.count > 1,
      let rhs = nodes.popLast(),
      let lhs = nodes.popLast()
    {
      nodes.append(.node(left: lhs, right: rhs))
      nodes.sort(by: >)
    }
    
    if let root = nodes.first {
      return root
    } else {
      throw HuffmanError.treeBuilderFailure
    }
  }
  
  func createTreeData(
    from node: HuffmanNode<UInt8>
  ) -> Data {
    switch node {
      case .node(let lhs, let rhs):
        let left = createTreeData(from: lhs)
        let right = createTreeData(from: rhs)
        let branchMarker = Data(repeating: 0, count: 1)
        return branchMarker + left + right
        
      case .leaf(var value, var count):
        let valueData = Data(
          bytes: &value,
          count: MemoryLayout<UInt8>.size
        )
        let countData = Data(
          bytes: &count,
          count: MemoryLayout<Int>.size
        )
        let leafMarker = Data(repeating: 1, count: 1)
        return leafMarker + countData + valueData
    }
  }
  
  func encodeText(
    _ text: String,
    with root: HuffmanNode<UInt8>,
    frequencies: [UInt8: Int]
  ) throws -> (data: Data, numberOfBits: Int) {
    
    let codes = root.codeMap()
    let numberOfBits = frequencies
      .reduce(into: 0) { result, args in
        let (byte, count) = args
        let mapping = codes[byte, default: (Data(), 0)]
        result += mapping.bitLength * count
      }
    
    let numberOfBytes = 1 + (numberOfBits - 1) / 8
    var encoding = Data(
      repeating: 0,
      count: numberOfBytes
    )
    
    var textVar = text
    var index = 0
    try textVar.withUTF8 { pointer in
      try pointer.forEach { byte in
        guard let (bits, bitCount) = codes[byte]
        else { throw HuffmanError.textEncodingFailure }
        for offset in 0 ..< bitCount {
          let mask: UInt8 = 0x80 >> (offset % 8)
          let masked = bits[offset / 8] & mask
          if masked > 0 {
            encoding[index / 8] |= 0x80 >> (index % 8)
          }
          index += 1
        }
      }
    }
    return (encoding, numberOfBits)
  }
}
