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

#if DEBUG
#Preview {
  let modelContainer = DataModel.shared.previewContainer
  return TimelineStatsView()
    .environment(AppStates())
    .modelContainer(modelContainer)
}
#endif
