// Created for BookingSense on 08.12.24 by kenny
// Using Swift 6.0

import Foundation
import SwiftUI
import SwiftData

struct EntryView: View {
  @Environment(AppStates.self) var appStates
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) var dismiss

  var bookingEntry: BookingEntry

  @State var presentingEntry: BookingEntry?
  @AppStorage("isExpandedBookingConversions") private var isExpandedBookingConversions: Bool = true
  @AppStorage("isExpandedTimelineStatistics") private var isExpandedTimelineStatistics: Bool = true

  var body: some View {
    List {
      bookingData
      BookingConversionsView(
        bookingInterval: Interval(rawValue: bookingEntry.interval),
        bookingType: BookingType(rawValue: bookingEntry.bookingType),
        bookingAmount: bookingEntry.amount,
        isExpandedBookingConversions: $isExpandedBookingConversions
      )
      if let timelineEntries = bookingEntry.timelineEntries {
        if !timelineEntries.isEmpty {
          TimelineInfosView(timelineEntries: timelineEntries,
                            isExpandedTimelineStatistics: $isExpandedTimelineStatistics
          )
        }
      }
    }
    .listStyle(.sidebar)
    .listSectionSpacing(.compact)
    .navigationTitle(bookingEntry.name)
    .toolbar {
      ToolbarViewEntry {
        presentingEntry = bookingEntry
      }
    }
    .sheet(item: $presentingEntry, onDismiss: didDismiss) { entry in
      EntryEditView(bookingEntry: entry) {
        dismiss()
      }
    }
  }

  @ViewBuilder
  var footerView: some View {
    if let nextBooking = bookingEntry.getNextBookingDate() {
      Text("Next booking \(nextBooking.bookingEntryNextDateFormatting())")
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
