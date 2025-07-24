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

  func tickTimelineEntriesUntilTodayEntries() {
    let today = Calendar.current.startOfDay(for: .now)
    let timelineEntryStateDone = TimelineEntryState.open.rawValue

    do {
      let context = ModelContext(DataModel.shared.modelContainer)
      let entries = try context.fetch(
        FetchDescriptor<BookingSchemaV5.TimelineEntry>(
          predicate: #Predicate { $0.isDue <= today && $0.state == timelineEntryStateDone },
        )
      )

      if entries.count == 0 {
        logger.debug("no entries to tick")
        return
      } else {
        logger.debug("found \(entries.count) entries to tick")
      }

      for entry in entries {
        entry.completedAt = entry.isDue
        entry.state = TimelineEntryState.done.rawValue
      }
      try context.save()
    } catch {
      logger.info("Failed to tick entries: \(error)")
    }
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
    let autoTimeline = UserDefaults(suiteName: "group.com.chill.BookingSense")?.bool(forKey: "autoTimeline") ?? false
    if autoTimeline {
      tickTimelineEntriesUntilTodayEntries()
    }
    var entries: [BookingTimeEntry] = []
    var snapshots: [TimelineEntryEntity] = []
    let timelineEntry = getTimelineEntries(for: configuration)
    let twentyFourHours: TimeInterval = 60 * 60 * 24

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

    return Timeline(entries: entries, policy: .after(.now + twentyFourHours))
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
