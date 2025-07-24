// Created for BookingSense on 15.06.25 by kenny
// Using Swift 6.0

import AppIntents

struct FindBookingEntry: AppIntent {
  static var title: LocalizedStringResource = "Find booking entries"
  static var description = IntentDescription("Allows the user to find booking entries")

  @Parameter(title: "Booking Entry")
  var bookingEntries: [BookingEntryEntity]

  func perform() async throws -> some IntentResult & ReturnsValue<[BookingEntryEntity]> {
    return .result(value: bookingEntries)
  }
}
