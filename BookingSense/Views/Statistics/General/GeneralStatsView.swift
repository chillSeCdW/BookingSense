// Created for BookingSense on 18.03.25 by kenny
// Using Swift 6.0

import Foundation
import SwiftUI
import SwiftData
import BookingSenseData

struct GeneralStatsView: View {
  @Query(filter: #Predicate<BookingEntry> { $0.state == "active" }) private var entries: [BookingEntry]

  @AppStorage("expandedBasic") private var isExpandedBasic = true
  @AppStorage("expandedAdditional") private var isAdditionalInfo = false
  @AppStorage("expandedCharts") private var isExpandedCharts = false
  @AppStorage("insightsInterval") private var interval: Interval = .monthly

  var totalData: [BookingEntryChartData] {

    let sumForAllPlusForInterval = entries.filter {
      $0.bookingType == BookingType.plus.rawValue
    }
      .map { entry in
        entry.amount * Constants.getTimesValue(from: Interval(rawValue: entry.interval), to: interval)
      }
      .reduce(0, +)

    let sumForAllMinusForInterval = entries.filter {
      $0.bookingType == BookingType.minus.rawValue
    }
      .map { entry in
        entry.amount * Constants.getTimesValue(from: Interval(rawValue: entry.interval), to: interval)
      }
      .reduce(0, +)

    let sumForAllSavingForInterval = entries.filter {
      $0.bookingType == BookingType.saving.rawValue
    }
      .map { entry in
        entry.amount * Constants.getTimesValue(from: Interval(rawValue: entry.interval), to: interval)
      }
      .reduce(0, +)

    let totalLeft = sumForAllPlusForInterval - (sumForAllMinusForInterval + sumForAllSavingForInterval)

    if totalLeft < 0 {
      return [BookingEntryChartData(id: "empty", name: String(localized: "No valid data"), amount: 1, color: .gray)]
    }

    if sumForAllPlusForInterval == 0 && sumForAllMinusForInterval == 0 && sumForAllSavingForInterval == 0 {
      return [BookingEntryChartData(id: "empty", name: String(localized: "No data"), amount: 1, color: .gray)]
    }

    return [
      BookingEntryChartData(id: "Total costs",
                            name: String(localized: "Total costs"),
                            amount: sumForAllMinusForInterval,
                            color: StyleHelper.getListBackgroundColor(for: BookingType.minus)),
      BookingEntryChartData(id: "Total savings",
                            name: String(localized: "Total savings"),
                            amount: sumForAllSavingForInterval,
                            color: StyleHelper.getListBackgroundColor(for: BookingType.saving)),
      BookingEntryChartData(id: "Total left",
                            name: String(localized: "Total left"),
                            amount: totalLeft,
                            color: StyleHelper.getListBackgroundColor(for: BookingType.plus))
    ].sorted(by: { entry1, entry2 in
      entry1.amount > entry2.amount
    })
  }

  var body: some View {
      List {
        Section("Select Interval") {
          Picker("Interval", selection: $interval) {
            ForEach(Interval.allCases) { option in
              Text(String(describing: option.description))
            }
          }
          .accessibilityIdentifier("intervalPicker")
          .pickerStyle(.automatic)
        }
        Section(LocalizedStringKey("\(interval.description) Insights"), isExpanded: $isExpandedBasic) {
          VStack {
            ChartView(data: totalData, headerTitle: String(localized: "\(interval.description.capitalized) Overview"))
            IntervalInsightsView()
          }
        }
        Section("Charts", isExpanded: $isExpandedCharts) {
          ChartsView()
        }
        Section("Additional \(interval.description) Infos", isExpanded: $isAdditionalInfo) {
          AdditionalInfoView()
        }
        .padding(.bottom)
      }
      .listStyle(.sidebar)
    }
}
