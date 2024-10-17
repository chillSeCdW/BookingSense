//
//  OverviewView.swift
//  BookingSense
//
//  Created by kenny on 27.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct OverviewView: View {
  @Query private var entries: [BookingEntry]

  @AppStorage("expandedBasic") private var isExpandedBasic = true
  @AppStorage("expandedAdditional") private var isAdditionalInfo = false
  @AppStorage("expandedCharts") private var isExpandedCharts = false
  @AppStorage("insightsInterval") private var interval: Interval = .monthly

  var totalData: [BookingEntryChartData] {

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
      BookingEntryChartData(id: "Total costs",
                            name: String(localized: "Total costs"),
                            amount: sumForAllMinusForInterval),
      BookingEntryChartData(id: "Total savings",
                            name: String(localized: "Total savings"),
                            amount: sumForAllSavingForInterval),
      BookingEntryChartData(id: "Total left",
                            name: String(localized: "Total left"),
                            amount: totalLeft)
    ]
  }

  var body: some View {
    NavigationStack {
      List {
        Section("Select Interval") {
          Picker("Interval", selection: $interval) {
            ForEach(Interval.allCases) { option in
              Text(String(describing: option.description))
            }
          }.accessibilityIdentifier("intervalPicker")
            .pickerStyle(.menu)
        }
        Section(LocalizedStringKey("\(interval.description) Insights"), isExpanded: $isExpandedBasic) {
          ChartView(data: totalData, headerTitle: String(localized: "\(interval.description.capitalized) Overview"))
          IntervalInsightsView()
        }
        Section("Charts", isExpanded: $isExpandedCharts) {
          ChartsView()
        }
        Section("Additional \(interval.description) Infos", isExpanded: $isAdditionalInfo) {
          AdditionalInfoView()
        }
      }
      .navigationTitle("Overview")
      .listStyle(.sidebar)
      .toolbar {
        ToolbarOverviewList()
      }
    }
  }
}

#Preview {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return OverviewView()
    .environment(SearchInfo())
    .modelContainer(factory.container)
}
