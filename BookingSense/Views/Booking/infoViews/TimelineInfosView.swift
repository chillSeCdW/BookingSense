// Created for BookingSense on 15.01.25 by kenny
// Using Swift 6.0

import SwiftUI
import BookingSenseData

struct TimelineInfosView: View {
  @Environment(AppStates.self) var appStates

  var timelineEntries: [TimelineEntry]

  @Binding var isExpandedTimelineStatistics: Bool

  var body: some View {
    Section("Timeline statistics",
            isExpanded: $isExpandedTimelineStatistics) {
      totalBookings
      totalBookingsAmount
      totalBookingsOnTime
      totalBookingsOffTime
    }
  }

  @ViewBuilder
  var totalBookings: some View {
    HStack {
      Text("total bookings completed")
      Spacer()
      Text("total bookings completed count \(timelineEntries.filter { $0.completedAt != nil }.count)")
        .foregroundColor(.secondary)
        .blur(radius: appStates.blurSensitive ? 5.0 : 0)
    }
  }

  @ViewBuilder
  var totalBookingsAmount: some View {
    HStack {
      Text("total bookings amount")
      Spacer()
      Text("total bookings completed amount \(getTotalBookingsAmount().generateFormattedCurrency())")
        .foregroundColor(.secondary)
        .blur(radius: appStates.blurSensitive ? 5.0 : 0)
    }
  }

  @ViewBuilder
  var totalBookingsOnTime: some View {
    HStack {
      Text("total bookings on time")
      Spacer()
      Text("total bookings on time count \(getOnTimeBookingsCount())")
        .foregroundColor(.secondary)
        .blur(radius: appStates.blurSensitive ? 5.0 : 0)
    }
  }

  @ViewBuilder
  var totalBookingsOffTime: some View {
    HStack {
      Text("total bookings off time")
      Spacer()
      Text("total bookings off time count \(getOffTimeBookingsCount())")
        .foregroundColor(.secondary)
        .blur(radius: appStates.blurSensitive ? 5.0 : 0)
    }
  }

  func getTotalBookingsAmount() -> Decimal {
    timelineEntries.filter { $0.completedAt != nil }
      .map(\.amount)
      .reduce(0, +)
  }

  func getOnTimeBookingsCount() -> Int {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
    var count = 0

    timelineEntries.forEach { entry in
      if let completedAt = entry.completedAt {
        if calendar.compare(entry.isDue, to: completedAt, toGranularity: .day) == .orderedSame {
          count += 1
        }
      }
    }
    return count
  }

  func getOffTimeBookingsCount() -> Int {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
    var count = 0

    timelineEntries.forEach { entry in
      if let completedAt = entry.completedAt {
        if calendar.compare(entry.isDue, to: completedAt, toGranularity: .day) != .orderedSame {
          count += 1
        }
      }
    }
    return count
  }
}
