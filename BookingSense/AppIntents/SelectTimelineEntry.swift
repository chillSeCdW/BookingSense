// Created for BookingSense on 15.06.25 by kenny
// Using Swift 6.0

import AppIntents

struct SelectTimelineEntry: AppIntent {

  static var title: LocalizedStringResource = "Select a timeline entry"
  static var description = IntentDescription("Allows the user to select a timeline entry")

  @Parameter(title: "Timeline Entry")
  var timelineEntry: TimelineEntryEntity

  func perform() async throws -> some IntentResult & ReturnsValue<TimelineEntryEntity> {
    return .result(value: timelineEntry)
  }
}
