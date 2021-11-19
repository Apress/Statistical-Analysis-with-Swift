public func printExampleSeparator() {
  print(
    """
    
    ------------------------------------------------------------------------------------------------
    
    """
  )
}


public func printExampleTitle<T: StringProtocol>(_ title: T) {
  print(title.uppercased(), terminator: "\n\n")
}
