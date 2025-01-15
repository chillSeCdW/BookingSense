// Created for BookingSense on 09.01.25 by kenny
// Using Swift 6.0

import SwiftUI

struct BookingConversionsView: View {
  @Environment(AppStates.self) var appStates

  var bookingInterval: Interval?
  var bookingType: BookingType?
  var bookingAmount: Decimal?

  @Binding var isExpandedBookingConversions: Bool

  var body: some View {
    Section("Booking conversions",
            isExpanded: $isExpandedBookingConversions) {
      ForEach(Interval.allCases, id: \.self) { interval in
        if interval.rawValue != bookingInterval?.rawValue {
          bookingBreakdown(
            interval: interval,
            bookingTypeString: bookingType?.description ?? ""
          )
        }
      }
    }
  }

  @ViewBuilder
  func bookingBreakdown(interval: Interval, bookingTypeString: String) -> some View {
    HStack {
      Text("breakdown \(interval.description.capitalized) \(bookingTypeString.lowercased())")
      Spacer()
      Text(Constants.calculateCostOf(
        entryInterval: bookingInterval ?? .monthly,
        entryAmount: bookingAmount ?? 0,
        to: interval).generateFormattedCurrency()
      )
      .foregroundColor(.secondary)
      .blur(radius: appStates.blurSensitive ? 5.0 : 0)
    }
  }
}
