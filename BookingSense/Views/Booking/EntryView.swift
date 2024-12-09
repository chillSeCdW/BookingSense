// Created for BookingSense on 08.12.24 by kenny
// Using Swift 6.0

import Foundation
import SwiftUI
import SwiftData

struct EntryView: View {
  @Environment(AppStates.self) var appStates
  @Environment(\.modelContext) private var modelContext

  @Query private var entries: [BookingEntry]

  var bookingEntry: BookingEntry

  @State var presentingEntry: BookingEntry?

  var body: some View {
    List {
      bookingData
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

  @ViewBuilder
  var footerView: some View {
    if let nextBooking = getNextBookingAsString() {
      Text("Next booking \(nextBooking)")
        .font(.caption)
        .foregroundStyle(.secondary)
        .blur(radius: appStates.blurSensitive ? 5.0 : 0)
    }
  }

  @ViewBuilder
  var bookingData: some View {
    Section(header: Text("Booking"), footer: footerView) {
      HStack {
        Text("Name:")
        Spacer()
        Text(bookingEntry.name)
          .foregroundColor(.secondary)
          .blur(radius: appStates.blurSensitive ? 5.0 : 0)
      }
      if let type = BookingType(rawValue: bookingEntry.bookingType) {
        HStack {
          Text("Booking type:")
          Spacer()
          Text(type.description)
            .foregroundColor(Constants.getListBackgroundColor(for: type))
            .blur(radius: appStates.blurSensitive ? 5.0 : 0)
        }
      }
      if let state = BookingEntryState(rawValue: bookingEntry.state)?.description {
        HStack {
          Text("State:")
          Spacer()
          Text(state)
            .foregroundColor(.secondary)
            .blur(radius: appStates.blurSensitive ? 5.0 : 0)
        }
      }
      HStack {
        Text("Amount:")
        Spacer()
        Text(bookingEntry.amount.generateFormattedCurrency())
          .blur(radius: appStates.blurSensitive ? 5.0 : 0)
          .foregroundColor(.secondary)
      }
      if let interval = Interval(rawValue: bookingEntry.interval)?.description {
        HStack {
          Text("Interval:")
          Spacer()
          Text(interval)
            .foregroundColor(.secondary)
            .blur(radius: appStates.blurSensitive ? 5.0 : 0)
        }
      }
      if let date = bookingEntry.date {
        HStack {
          Text("Start date:")
          Spacer()
          Text(date.bookingEntryNextDateFormatting())
            .foregroundColor(.secondary)
            .blur(radius: appStates.blurSensitive ? 5.0 : 0)
        }
      }
    }
    if let tag = bookingEntry.tag {
      Section(header: Text("Tag")) {
        HStack {
          Text("Tag:")
          Spacer()
          Text(tag.name)
            .foregroundColor(.secondary)
            .blur(radius: appStates.blurSensitive ? 5.0 : 0)
        }
      }
    }
  }

  func didDismiss() {
    presentingEntry = nil
  }

  func getNextBookingAsString() -> String? {
    let latestEntry = bookingEntry.timelineEntries?.filter { entry in
      entry.bookingEntry?.uuid == bookingEntry.uuid && entry.state == TimelineEntryState.open.rawValue
    }.sorted(by: { $0.isDue < $1.isDue })

    if let bookDate = bookingEntry.date {
      if let entry = latestEntry?.first {
        return entry.isDue.bookingEntryNextDateFormatting()
      }
      return bookDate.bookingEntryNextDateFormatting()
    }
    return nil
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
