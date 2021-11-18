import SwiftUI
import StatKit

@main
struct Chapter5App: App {
  static let measurements = (1 ... 100).map { _ in Int.random(in: 0 ... 5).realValue }
  static let numberOfSamples = 30
  static let numberOfMeans = 5_000
  
  var body: some Scene {
    WindowGroup {
      Text(
        """
        This app is not meant to be launched.
        Have a look at the previews in the source files instead. 😃
        """
      )
      .multilineTextAlignment(.center)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .windowStyle(HiddenTitleBarWindowStyle())
  }
}
