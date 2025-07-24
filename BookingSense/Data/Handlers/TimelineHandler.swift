// Created for BookingSense on 15.06.25 by kenny
// Using Swift 6.0

import OSLog
import Foundation
import SwiftData
import BookingSenseData

private let logger = Logger(subsystem: "BookingSense", category: "TimelineHandler")

class TimelineHandler {

  static func tickTimelineEntriesUntilTodayEntries(context: ModelContext) -> Int {
    let today = Calendar.current.startOfDay(for: .now)
    let timelineEntryStateDone = TimelineEntryState.open.rawValue
    var count = 0

    let fetchDescriptor = FetchDescriptor<TimelineEntry>(
      predicate: #Predicate { $0.isDue <= today && $0.state == timelineEntryStateDone },
    )

    do {
      let entries = try context.fetch(fetchDescriptor)

      if entries.count == 0 {
        logger.debug("no entries to tick")
        return 0
      } else {
        count = entries.count
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

    return count
  }
}
