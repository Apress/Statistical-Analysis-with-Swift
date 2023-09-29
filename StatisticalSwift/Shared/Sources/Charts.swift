import SwiftUI
import DGCharts
import Cocoa

private let chartColor = NSColor(
  red: 0x23 / 255.0,
  green: 0x93 / 255.0,
  blue: 0xd2 / 255.0,
  alpha: 1
)

public struct LineChart: NSViewRepresentable {
  private let data: [ChartDataEntry]
  private let label: String
  
  public init(data: [ChartDataEntry], label: String) {
    self.data = data
    self.label = label
  }
  
  public func makeNSView(context: Context) -> LineChartView {
    let chart = LineChartView()
    chart.rightAxis.enabled = false
    chart.xAxis.labelPosition = .bottom
    chart.leftAxis.axisMinimum = 0
    return chart
  }
  
  public func updateNSView(_ nsView: LineChartView, context: Context) {
    let dataset = LineChartDataSet(entries: data)
    
    dataset.drawCirclesEnabled = false
    dataset.drawValuesEnabled = false
    dataset.drawFilledEnabled = true
    dataset.label = label
    dataset.setColor(chartColor)
    dataset.fillColor = chartColor.withAlphaComponent(0.2)
    
    nsView.data = LineChartData(dataSet: dataset)
  }
}

public struct Histogram: NSViewRepresentable {
  private let data: [BarChartDataEntry]
  private let label: String
  private let barWidth: Double
  private let xAxisMin: Double?
  private let xAxisMax: Double?
  
  public init(data: [BarChartDataEntry], label: String, barWidth: Double = 0.85, xAxisMin: Double? = .none, xAxisMax: Double? = .none) {
    self.data = data
    self.label = label
    self.barWidth = barWidth
    self.xAxisMin = xAxisMin
    self.xAxisMax = xAxisMax
  }
  
  public func makeNSView(context: Context) -> BarChartView {
    let chart = BarChartView()
    chart.rightAxis.enabled = false
    chart.xAxis.labelPosition = .bottom
    chart.leftAxis.axisMinimum = 0
    
    if let min = xAxisMin {
      chart.xAxis.axisMinimum = min
    }
    
    if let max = xAxisMax {
      chart.xAxis.axisMaximum = max
    }
    
    return chart
  }
  
  public func updateNSView(_ nsView: BarChartView, context: Context) {
    let dataset = BarChartDataSet(entries: data)
    
    dataset.drawValuesEnabled = false
    dataset.label = label
    dataset.setColor(chartColor)
    
    let data = BarChartData(dataSet: dataset)
    data.barWidth = self.barWidth
    nsView.data = data
  }
}
