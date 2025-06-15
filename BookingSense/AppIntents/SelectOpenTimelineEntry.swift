// Created for BookingSense on 15.06.25 by kenny
// Using Swift 6.0

import AppIntents

struct SelectOpenTimelineEntry: AppIntent {
  static var title: LocalizedStringResource = "Select open timeline entry"
  static var description = IntentDescription("Allows the user to select a timeline entry from the next 10 open entries")

  @Parameter(title: "Timeline Entry")
  var timelineEntry: OpenTimelineEntryEntity

  func perform() async throws -> some IntentResult & ReturnsValue<OpenTimelineEntryEntity> {
    return .result(value: timelineEntry)
  }
}
