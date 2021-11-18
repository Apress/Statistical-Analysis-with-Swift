import SwiftUI
import StatKit

struct IQHypothesisTest: View {
  private var probability: Double {
    let sdScalar = sqrt(numberOfStudents.realValue)
    let normalDist = NormalDistribution(
      mean: 100,
      standardDeviation: 15 / sdScalar
    )
    return 1 - normalDist.cdf(x: averageIQScore)
  }
  
  @State private var averageIQScore: Double = 105
  @State private var numberOfStudents: Int = 30
  
  var body: some View {
    VStack(alignment: .center, spacing: 20) {
      VStack {
        Text("IQ Hypothesis Test")
          .font(.largeTitle)
        
        Text(
          """
          \(numberOfStudents) sampled students
          Average score of \(averageIQScore, specifier: "%.1f")
          """
        )
        .font(.subheadline)
        .multilineTextAlignment(.center)
      }
      
      Text(
        """
        There is a \(
          probability * 100,
          specifier: "%.2f"
        )% chance that the computed
        mean belongs to the null hypothesis.
        """
      )
      .multilineTextAlignment(.center)
      
      Text(
        """
        We can be \((1 - probability) * 100, specifier: "%.2f")% confident if we reject
        the null hypothesis!
        """
      )
      .multilineTextAlignment(.center)
    }
  }
}

struct IQHypothesisTest_Previews: PreviewProvider {
  static var previews: some View {
    IQHypothesisTest()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
