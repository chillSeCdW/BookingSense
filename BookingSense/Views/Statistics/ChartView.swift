// Created for BookingSense on 17.10.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData
import Charts
import BookingSenseData

struct ChartView<Content: View>: View {
  @Environment(AppStates.self) var appStates

  var data: [BookingEntryChartData]
  var headerTitle: String
  var isFixedColor: Bool {
    data.first?.color != nil
  }
  let contentView: Content

  @AppStorage("insightsInterval") private var interval: Interval = .monthly

  @State var selectedPie: Double?

  init(data: [BookingEntryChartData],
       headerTitle: String,
       selectedPie: Double? = nil,
       @ViewBuilder contentView: () -> Content = { EmptyView() }) {
    self.data = data
    self.headerTitle = headerTitle
    self.selectedPie = selectedPie
    self.contentView = contentView()
  }

  var highestData: (BookingEntryChartData)? {
    return data.max(by: { $0.amount < $1.amount })
  }

  var totalAmount: (Decimal) {
    return data.map(\.amount).reduce(0, +)
  }

  var cumulativeDataRangesForStyles: [(name: String, range: Range<Double>)] {
    var cumulative = 0.0
    return data.map {
      let newCumulative = cumulative + Double(truncating: abs($0.amount) as NSNumber)
      let result = (name: $0.name, range: cumulative ..< newCumulative)
      cumulative = newCumulative
      return result
    }
  }

  var selectedStyle: (BookingEntryChartData)? {
    if let selectedPie,
       let selectedIndex = cumulativeDataRangesForStyles
      .firstIndex(where: { $0.range.contains(selectedPie) }) {
      return data[selectedIndex]
    }
    return nil
  }

  var percentOfSelectedAmount: Decimal {
    (selectedStyle?.amount ?? highestData?.amount ?? Decimal()) / totalAmount
  }

  var body: some View {
    VStack {
      Text(LocalizedStringKey(headerTitle))
        .font(.title2)
        .bold()
      contentView
      if isFixedColor {
        fixedColorChart(data.first?.id == "empty")
      } else {
        chart()
      }
    }
  }

  func fixedColorChart(_ noData: Bool) -> some View {
    Chart(data, id: \.id) { element in
      SectorMark(
        angle: .value("Amount", element.amount),
        innerRadius: .ratio(0.618),
        angularInset: 1.5
      )
      .cornerRadius(5)
      .foregroundStyle(by: .value("Name", element.name))
      .opacity(element.name == (selectedStyle?.name ?? highestData?.name) ? 1 : 0.3)
    }
    .chartLegend(noData ? .hidden : .visible)
    .chartLegend(alignment: .center, spacing: 5)
    .chartForegroundStyleScale(range: graphColors(for: data))
    .chartAngleSelection(value: $selectedPie)
    .scaledToFit()
    .frame(maxHeight: 500)
    .chartBackground { chartProxy in
      GeometryReader { geometry in
        let frame = geometry[chartProxy.plotFrame!]
        VStack {
          Text("\(percentOfSelectedAmount.generateFormattedPercent()) / 100%")
            .font(.callout)
            .foregroundStyle(.secondary)
          Text(LocalizedStringKey(selectedStyle?.name ?? highestData?.name ?? ""))
            .font(.title3.bold())
            .foregroundColor(.primary)
            .frame(maxWidth: frame.width/2)
          Text(selectedStyle?.amount ?? highestData?.amount ?? Decimal(),
               format: .currency(code: Locale.current.currency!.identifier)
          )
          .blur(radius: appStates.blurSensitive ? 5.0 : 0)
          .font(.callout)
          .bold()
          .foregroundStyle(.secondary)
          .opacity(noData ? 0 : 1)
          Text("from")
            .font(.footnote)
            .opacity(noData ? 0 : 1)
          Text(totalAmount,
               format: .currency(code: Locale.current.currency!.identifier)
          )
          .blur(radius: appStates.blurSensitive ? 5.0 : 0)
          .font(.callout)
          .foregroundStyle(.secondary)
          .opacity(noData ? 0 : 1)
        }
        .animation(.easeInOut, value: appStates.blurSensitive)
        .position(x: frame.midX, y: frame.midY)
      }
    }
  }

  func chart() -> some View {
    Chart(data, id: \.id) { element in
      SectorMark(
        angle: .value("Amount", element.amount),
        innerRadius: .ratio(0.618),
        angularInset: 1.5
      )
      .cornerRadius(5)
      .foregroundStyle(by: .value("Name", element.name))
      .opacity(element.name == (selectedStyle?.name ?? highestData?.name) ? 1 : 0.3)
    }
    .chartLegend(.hidden)
    .chartAngleSelection(value: $selectedPie)
    .scaledToFit()
    .chartBackground { chartProxy in
      GeometryReader { geometry in
        let frame = geometry[chartProxy.plotFrame!]
        VStack {
          Text("\(percentOfSelectedAmount.generateFormattedPercent()) / 100%")
            .font(.callout)
            .foregroundStyle(.secondary)
          Text(LocalizedStringKey(selectedStyle?.name ?? highestData?.name ?? ""))
            .font(.title3.bold())
            .foregroundColor(.primary)
            .frame(maxWidth: frame.width/2)
            .multilineTextAlignment(.center)
            .blur(radius: appStates.blurSensitive ? 5.0 : 0)
          Text(selectedStyle?.amount ?? highestData?.amount ?? Decimal(),
               format: .currency(code: Locale.current.currency!.identifier)
          )
          .blur(radius: appStates.blurSensitive ? 5.0 : 0)
          .font(.callout)
          .foregroundStyle(.secondary)
          Text("from")
            .font(.footnote)
          Text(totalAmount,
               format: .currency(code: Locale.current.currency!.identifier)
          ).blur(radius: appStates.blurSensitive ? 5.0 : 0)
            .font(.callout)
            .foregroundStyle(.secondary)
        }
        .animation(.easeInOut, value: appStates.blurSensitive)
        .position(x: frame.midX, y: frame.midY)
      }
    }
  }

  func graphColors(for entries: [BookingEntryChartData]) -> [Color] {
          var returnColors = [Color]()
          for entry in entries {
            returnColors.append(entry.color!)
          }
          return returnColors
      }
}

#Preview {
  @Previewable @State var chartType: ChartType = .interval

  ChartView(data: [], headerTitle: "Monthly Minus") {
    Picker("Chart Type", selection: $chartType) {
      ForEach(ChartType.allCases) { option in
        Text(LocalizedStringKey(option.description))
      }
    }
    .pickerStyle(.segmented)
  }
}
