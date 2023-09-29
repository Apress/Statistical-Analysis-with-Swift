import SwiftUI
import StatKit
import StatisticalSwift
import DGCharts

struct DistributionOfSampleMeans: View {
  private let data: [BarChartDataEntry]
  private let barWidth: Double
  private let mean: Double
  private let numberOfSamples: Int
  
  init(
    numberOfMeans: Int,
    numberOfSamples: Int,
    sampledFrom set: [Double]
  ) {
    precondition(
      !set.isEmpty,
      "Samples need to contain at least one element."
    )
    
    // Used to place values into a histogram bin
    let rounding = 0.1
    
    let meansIterator = (1 ... numberOfMeans).lazy
    let samplesIterator = (1 ... numberOfSamples).lazy
    
    self.data = meansIterator
      .map { _ in
        samplesIterator
          .compactMap { _ in set.randomElement() }
          .mean(of: \.self)
      }
      .reduce(into: [Double: Int]()) { dict, mean in
        let roundedMean = (mean / rounding)
          .rounded() * rounding
        dict[roundedMean, default: 0] += 1
      }
      .map { key, value in
        BarChartDataEntry(
          x: key,
          y: value.realValue / numberOfMeans.realValue
        )
      }
    
    self.barWidth = 0.9 * rounding
    self.mean = set.mean(of: \.self)
    self.numberOfSamples = numberOfSamples
  }
  
  var body: some View {
    VStack(spacing: 20) {
      Text("Computing Sample Means")
        .font(.largeTitle)
      
      HStack(spacing: 20) {
        Text("True mean: \(mean, specifier: "%.3f")")
        Text("Samples per mean: \(numberOfSamples)")
      }
      .padding(.horizontal)
      
      Histogram(
        data: data,
        label: "Distribution of sample means",
        barWidth: barWidth,
        xAxisMin: 0,
        xAxisMax: 5
      )
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static let xRange = stride(from: 0, through: 5, by: 0.05)
  static let measurements = (1 ... 100).map { _ in Int.random(in: 0 ... 5).realValue }
  static let sampleMean = measurements.mean(of: \.self)
  static let sampleStandardDeviation = measurements.standardDeviation(of: \.self, from: .sample)
  static let numberOfSamples = 30
  static let numberOfMeans = 5_000
  static let normalDistribution = NormalDistribution(
    mean: sampleMean,
    standardDeviation: sampleStandardDeviation / sqrt(numberOfSamples.realValue)
  )
  
  static var previews: some View {
    let mean = String(format: "%.3f", sampleMean)
    let sd = String(format: "%.3f", sampleStandardDeviation)
    
    return Group {
      DistributionOfSampleMeans(
        numberOfMeans: numberOfMeans,
        numberOfSamples: numberOfSamples,
        sampledFrom: measurements
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      
      LineChart(
        data: xRange.map { x in
          BarChartDataEntry(x: x.realValue, y: normalDistribution.pdf(x: x))
        },
        label: "Normal Distribution (μ = \(mean), σ = \(sd))"
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}
