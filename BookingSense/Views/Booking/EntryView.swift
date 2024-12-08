// Created for BookingSense on 08.12.24 by kenny
// Using Swift 6.0

import Foundation
import SwiftUI
import SwiftData

struct EntryView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.modelContext) private var modelContext

  @Query private var entries: [BookingEntry]

  var bookingEntry: BookingEntry

  @State var presentingEntry: BookingEntry?

  var body: some View {
    List {
      Text(bookingEntry.name)
      Text(bookingEntry.amount.generateFormattedCurrency())
      Text(bookingEntry.interval.description)
    }
    .listSectionSpacing(.compact)
    .navigationTitle(bookingEntry.name)
    .toolbar {
      ToolbarViewEntry {
        presentingEntry = bookingEntry
      }
    }
    .sheet(item: $presentingEntry, onDismiss: didDismiss) { entry in
      EntryEditView(bookingEntry: entry)
    }
  }

  func didDismiss() {
    presentingEntry = nil
  }
}

#Preview("View") {
  let entry = BookingEntry(
    name: "testName",
    amount: Decimal(string: "15,35", locale: Locale(identifier: Locale.current.identifier)) ?? Decimal(),
    bookingType: BookingType.plus.rawValue,
    interval: .weekly,
    tag: nil,
    timelineEntries: nil)

  return EntryView(bookingEntry: entry)
}
