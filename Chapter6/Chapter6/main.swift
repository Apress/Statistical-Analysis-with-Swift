import StatisticalSwift
import StatKit

printExampleTitle("Huffman Compression")

let text = DataLoader.loadText(from: .huffman)
let coder = HuffmanTextCoder()
let compressed = try coder.encode(text)

print(
  """
  Text size: \(text.utf8.count) bytes
  Data size: \(compressed.count) bytes
  
  """
)

let decompressed = try coder.decode(compressed)

print(
  """
  Decompressed text matches original:
  \(text == decompressed ? "YES" : "NO")
  """
)
