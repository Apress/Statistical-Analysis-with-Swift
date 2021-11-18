import Foundation

internal struct HuffmanTextCoder {
  enum HuffmanError: Error {
    case emptyInputData
    case treeBuilderFailure
    case textEncodingFailure
    case textDecodingFailure
  }
  
  internal func encode(_ text: String) throws -> Data {
    let byteFrequencies = countBytes(in: text)
    
    let root = try createHuffmanTree(
      from: byteFrequencies
    )
    
    let treeData = createTreeData(from: root)
    
    var (encodedText, encodingSize) = try encodeText(
      text,
      with: root,
      frequencies: byteFrequencies
    )
    
    let encodingSizeData = Data(
      bytes: &encodingSize,
      count: MemoryLayout<Int>.size
    )
    
    return encodingSizeData + treeData + encodedText
  }
  
  internal func decode(_ data: Data) throws -> String {
    let encodingSize = parseEncodingBitSize(data)
    
    var huffmanData = data[MemoryLayout<Int>.size...]
    
    let tree = parseTree(&huffmanData)
    
    let text = try parseText(
      from: huffmanData,
      using: tree,
      bitLength: encodingSize
    )
    
    return text
  }
}
