// Created for BookingSense on 18.03.25 by kenny
// Using Swift 6.0

import Foundation
import SwiftUI
import SwiftData
import BookingSenseData

struct TimelineStatsView: View {
  @Query private var entries: [TimelineEntry]

  @AppStorage("timelineStatsYear") private var selectedYear: Int?
  @AppStorage("timelineStatsStatus") private var selectedStatus: TimelineEntryState?

  private var availableYears: [Int] {
    guard !entries.isEmpty else {
      return []
    }

    let calendar = Calendar.current

    let years = entries.compactMap { entry in
      calendar.dateComponents([.year], from: entry.isDue).year
    }
    return Array(Set(years)).sorted()
  }

  private var filteredEntries: [TimelineEntry] {
    entries.filter { entry in
      selectedYear == nil || Calendar.current.dateComponents([.year], from: entry.isDue).year == selectedYear
    }
    .filter { entry in
      selectedStatus == nil || entry.state == selectedStatus?.rawValue
    }
  }

  var body: some View {
    List {
      Section(header: Text("Filter")) {
        Picker("Select period", selection: $selectedYear) {
          Text("All")
            .tag(nil as Int?)

          ForEach(availableYears, id: \.self) { year in
            Text(String(year))
              .tag(year as Int?)
          }
        }
        .pickerStyle(.menu)
        Picker("Select status", selection: $selectedStatus) {
          Text("All")
            .tag(nil as TimelineEntryState?)

          ForEach(TimelineEntryState.allCases, id: \.self) { status in
            Text(status.description)
              .tag(status)
          }
        }
        .pickerStyle(.menu)
      }
      Section("Booking type breakdown") {
        TimelineDiagramView(filteredEntries: filteredEntries)
      }
      Section("Total amount for period and status") {
        CalcViews(filteredEntries: filteredEntries)
      }
    }
  }
}

struct CalcViews: View {
  var filteredEntries: [TimelineEntry]

  private var totalAmountIncome: Decimal {
    filteredEntries.filter { $0.bookingType == BookingType.plus.rawValue }
      .reduce(0) { result, entry in
      result + entry.amount
    }
  }

  private var totalAmountDeductions: Decimal {
    filteredEntries.filter { $0.bookingType == BookingType.minus.rawValue }
      .reduce(0) { result, entry in
      result + entry.amount
    }
  }

  private var totalAmountSavings: Decimal {
    filteredEntries.filter { $0.bookingType == BookingType.saving.rawValue }
      .reduce(0) { result, entry in
      result + entry.amount
    }
  }

  var body: some View {
    InfoView(text: LocalizedStringKey("Income"),
             number: totalAmountIncome,
             format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(text: LocalizedStringKey("Deductions"),
             number: totalAmountDeductions,
             format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(text: LocalizedStringKey("Savings"),
             number: totalAmountSavings,
             format: .currency(code: Locale.current.currency!.identifier)
    )
  }
}

struct TimelineDiagramView: View {
  var filteredEntries: [TimelineEntry]

  var totalPlusData: [BookingEntryChartData] {
    return getFilteredMapData(bookingType: .plus)
  }

  var totalDeductionData: [BookingEntryChartData] {
    return getFilteredMapData(bookingType: .minus)
  }

  var totalSavingData: [BookingEntryChartData] {
    return getFilteredMapData(bookingType: .saving)
  }

  func getFilteredMapData(bookingType: BookingType) -> [BookingEntryChartData] {
    let bookingTypeEntries = filteredEntries.filter { $0.bookingType == bookingType.rawValue }

    let timelineEntriesByBookingUUID = Dictionary(grouping: bookingTypeEntries) { entry in
        entry.bookingEntry?.uuid ?? ""
    }

    let breakDownOfBookingType = timelineEntriesByBookingUUID.map { bookingUUID, entries in
      BookingEntryChartData(id: bookingUUID,
                              name: entries.first?.bookingEntry?.name ?? "",
                              amount: entries.reduce(0) { result, entry in
                                result + entry.amount
                              },
                              color: nil)
    }

    return checkDataAddEmpty(breakDownOfBookingType)
  }

  func checkDataAddEmpty(_ data: [BookingEntryChartData]) -> [BookingEntryChartData] {
    if data.isEmpty {
      return [BookingEntryChartData(id: "empty", name: String(localized: "No data"), amount: 1, color: .gray)]
    } else {
      return data
    }
  }

  var body: some View {
    ChartView(data: totalPlusData, headerTitle: String(localized: "Total timeline plus"))
    ChartView(data: totalDeductionData, headerTitle: String(localized: "Total timeline deductions"))
    ChartView(data: totalSavingData, headerTitle: String(localized: "Total timeline savings"))
  }
}

#if DEBUG
#Preview {
  let modelContainer = DataModel.shared.previewContainer
  return TimelineStatsView()
    .environment(AppStates())
    .modelContainer(modelContainer)
}
#endif
