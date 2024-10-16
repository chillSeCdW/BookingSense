// Created for BookingSense on 16.10.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData
import Charts

struct OverviewChartView: View {
  @Query private var entries: [BookingEntry]
  @AppStorage("insightsInterval") private var interval: Interval = .monthly
  @AppStorage("blurSensitive") private var blurSensitive = false

  @State var selectedPie: Double?

  var totalData: [(name: String, amount: Decimal)] {

    let sumForAllPlusForInterval = entries.filter { $0.amountPrefix == .plus }
      .map { entry in
        entry.amount * Constants.getTimesValue(from: Interval(rawValue: entry.interval), to: interval)
      }
      .reduce(0, +)

    let sumForAllMinusForInterval = entries.filter { $0.amountPrefix == .minus }
      .map { entry in
        entry.amount * Constants.getTimesValue(from: Interval(rawValue: entry.interval), to: interval)
      }
      .reduce(0, +)

    let sumForAllSavingForInterval = entries.filter { $0.amountPrefix == .saving }
      .map { entry in
        entry.amount * Constants.getTimesValue(from: Interval(rawValue: entry.interval), to: interval)
      }
      .reduce(0, +)

    let totalLeft = sumForAllPlusForInterval - (sumForAllMinusForInterval + sumForAllSavingForInterval)

    if totalLeft < 0 {
      return []
    }

    return [
      (name: "Total costs", amount: sumForAllMinusForInterval),
      (name: "Total savings", amount: sumForAllSavingForInterval),
      (name: "Total left", amount: sumForAllPlusForInterval - (sumForAllMinusForInterval + sumForAllSavingForInterval))
    ]
  }

  var highestData: (name: String, amount: Decimal)? {
    return totalData.max(by: { $0.amount < $1.amount })
  }

  var cumulativeDataRangesForStyles: [(name: String, range: Range<Double>)] {
    var cumulative = 0.0
    return totalData.map {
      let newCumulative = cumulative + Double(truncating: abs($0.amount) as NSNumber)
      let result = (name: $0.name, range: cumulative ..< newCumulative)
      cumulative = newCumulative
      return result
    }
  }

  var selectedStyle: (name: String, amount: Decimal)? {
    if let selectedPie,
       let selectedIndex = cumulativeDataRangesForStyles
      .firstIndex(where: { $0.range.contains(selectedPie) }) {
      return totalData[selectedIndex]
    }
    return nil
  }

  var body: some View {
    if !totalData.isEmpty {
      Chart(totalData, id: \.name) { element in
        SectorMark(
          angle: .value("Amount", element.amount),
          innerRadius: .ratio(0.618),
          angularInset: 1.5
        )
        .cornerRadius(5)
        .foregroundStyle(by: .value("Name", element.name))
        .opacity(element.name == (selectedStyle?.name ?? highestData?.name) ? 1 : 0.3)
      }
      .chartLegend(alignment: .center, spacing: 18)
      .chartAngleSelection(value: $selectedPie)
      .scaledToFit()
      .chartBackground { chartProxy in
        GeometryReader { geometry in
          let frame = geometry[chartProxy.plotFrame!]
          VStack {
            Text("Highest amount")
              .font(.callout)
              .foregroundStyle(.secondary)
              .opacity(selectedStyle == nil || selectedStyle?.name == highestData?.name ? 1 : 0)
            Text(LocalizedStringKey(selectedStyle?.name ?? highestData?.name ?? ""))
              .font(.title2.bold())
              .foregroundColor(.primary)
            Text(selectedStyle?.amount ?? highestData?.amount ?? Decimal(),
                 format: .currency(code: Locale.current.currency!.identifier)
            ).blur(radius: blurSensitive ? 5.0 : 0)
              .font(.callout)
              .foregroundStyle(.secondary)
          }
          .position(x: frame.midX, y: frame.midY)
        }
      }
    }
  }
}

#Preview {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return OverviewChartView()
    .modelContainer(factory.container)

}
