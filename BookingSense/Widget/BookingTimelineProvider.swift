// Created for BookingSense on 22.01.25 by kenny
// Using Swift 6.0

import OSLog
import SwiftData
import WidgetKit
import BookingSenseData

private let logger = Logger(subsystem: "BookingSenseWidget", category: "TimelineProvider")

struct BookingTimelineProvider: AppIntentTimelineProvider {

  func getTimelineEntries(for configuration: ConfigIntent) -> [BookingSchemaV5.TimelineEntry] {
    do {
      let data = try ModelContext(DataModel.shared.modelContainer).fetch(
        FetchDescriptor<BookingSchemaV5.TimelineEntry>(
          predicate: configuration.buildPredicate(),
          sortBy: [.init(\.isDue)]
        )
      )
      return data
    } catch {
      logger.error("\(error.localizedDescription)")
    }
    return []
  }

  func placeholder(in context: Context) -> BookingTimeEntry {
    return BookingTimeEntry(
      timelineEntrySnapshot: [TimelineEntryEntity(uuid: "someUUID",
                                                  state: TimelineEntryState.open,
                                                  name: "example name",
                                                  amount: 50,
                                                  bookingType: BookingType.minus,
                                                  isDue: .now,
                                                  completedAt: nil
                                                 )],
      date: .now,
      configuration: ConfigIntent()
    )
  }

  func snapshot(for configuration: ConfigIntent, in context: Context) async -> BookingTimeEntry {
    let timelineEntry = getTimelineEntries(for: configuration).first
    if let entry = timelineEntry {
      return BookingTimeEntry(
        timelineEntrySnapshot: [TimelineEntryEntity(from: entry)],
        date: entry.isDue,
        configuration: ConfigIntent()
      )
    }
    return BookingTimeEntry(
      timelineEntrySnapshot: [TimelineEntryEntity(uuid: "someUUID",
                                                  state: TimelineEntryState.open,
                                                  name: "example name",
                                                  amount: 50,
                                                  bookingType: BookingType.minus,
                                                  isDue: .now,
                                                  completedAt: nil
                                                 )],
      date: .now,
      configuration: configuration
    )
  }

  func timeline(for configuration: ConfigIntent, in context: Context) async -> Timeline<BookingTimeEntry> {
    var entries: [BookingTimeEntry] = []
    var snapshots: [TimelineEntryEntity] = []
    let timelineEntry = getTimelineEntries(for: configuration)
    let twelveHours: TimeInterval = 60 * 60 * 12

    timelineEntry.forEach { entry in
      snapshots.append(
        TimelineEntryEntity(from: entry)
      )
    }

    entries.append(
      BookingTimeEntry(
        timelineEntrySnapshot: snapshots,
        date: .now,
        configuration: configuration
      )
    )

    return Timeline(entries: entries, policy: .after(.now + twelveHours))
  }

  func recommendations() -> [AppIntentRecommendation<ConfigIntent>] {
      [
        AppIntentRecommendation(intent: ConfigIntent(typeOfBookings: .all), description: "All entries"),
        AppIntentRecommendation(intent: ConfigIntent(typeOfBookings: .minus), description: "Outgoing entries"),
        AppIntentRecommendation(intent: ConfigIntent(typeOfBookings: .plus), description: "Incoming entries"),
        AppIntentRecommendation(intent: ConfigIntent(typeOfBookings: .saving), description: "Saving entries")
      ]
  }

  //    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
  //        // Generate a list containing the contexts this widget is relevant in.
  //    }
}
