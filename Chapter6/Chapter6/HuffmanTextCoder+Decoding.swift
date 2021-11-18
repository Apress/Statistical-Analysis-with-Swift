import Foundation.NSData

extension HuffmanTextCoder {
  func parseEncodingBitSize(_ data: Data) -> Int {
    data.withUnsafeBytes { pointer in
      pointer.load(as: Int.self)
    }
  }
  
  func parseTree(
    _ data: inout Data
  ) -> HuffmanNode<UInt8> {
    
    let marker = data.first
    data = Data(data.dropFirst())
    
    switch marker {
      case 0:
        let left = parseTree(&data)
        let right = parseTree(&data)
        return .node(left: left, right: right)
        
      default:
        let (count, value) = data
          .withUnsafeBytes { pointer -> (Int, UInt8) in
            let count = pointer.load(as: Int.self)
            let value = pointer.load(
              fromByteOffset: MemoryLayout<Int>.size,
              as: UInt8.self
            )
            return (count, value)
          }
        
        let intSize = MemoryLayout<Int>.size
        let byteSize = MemoryLayout<UInt8>.size
        data = Data(data.dropFirst(intSize + byteSize))
        
        return .leaf(value: value, count: count)
    }
  }
  
  func parseText(
    from data: Data,
    using tree: HuffmanNode<UInt8>,
    bitLength: Int
  ) throws -> String {
    var textData = Data()
    if case .leaf(let value, _) = tree {
      textData.append(
        contentsOf: [UInt8](
          repeating: value,
          count: bitLength
        )
      )
    } else {
      var index = 0
      var currentNode = tree
      while index <= bitLength {
        switch currentNode {
          case .leaf(let value, _):
            textData.append(value)
            currentNode = tree
          
          case .node(let lhs, let rhs):
            let mask = UInt8(0x80) >> (index % 8)
            let step = data[index / 8] & mask
            currentNode = step > 0 ? rhs : lhs
            index += 1
        }
      }
    }
    guard let text = String(
        data: textData,
        encoding: .utf8
      )
    else { throw HuffmanError.textDecodingFailure }
    return text
  }
}
