// Created for BookingSense on 15.06.25 by kenny
// Using Swift 6.0

import AppIntents

struct SelectBookingEntry: AppIntent {
  static var title: LocalizedStringResource = "Select booking entry"
  static var description = IntentDescription("Allows the user to select a booking entry")

  @Parameter(title: "Booking Entry")
  var bookingEntry: BookingEntryEntity

  func perform() async throws -> some IntentResult & ReturnsValue<BookingEntryEntity> {
    return .result(value: bookingEntry)
  }
}
