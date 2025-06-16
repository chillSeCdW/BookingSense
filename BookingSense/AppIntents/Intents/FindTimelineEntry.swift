// Created for BookingSense on 15.06.25 by kenny
// Using Swift 6.0

import AppIntents

struct FindTimelineEntry: AppIntent {

  static var title: LocalizedStringResource = "Find timeline entries"
  static var description = IntentDescription("Allows the user to find timeline entries")

  @Parameter(title: "Timeline Entry")
  var timelineEntries: [TimelineEntryEntity]

  func perform() async throws -> some IntentResult & ReturnsValue<[TimelineEntryEntity]> {
    return .result(value: timelineEntries)
  }
}
