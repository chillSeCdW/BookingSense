// Created for BookingSense on 15.06.25 by kenny
// Using Swift 6.0

import Foundation
import SwiftData
import BookingSenseData

class TimelineHandler {

  static func tickTimelineEntriesUntilTodayEntries(context: ModelContext) -> Int {
    let tomorrow = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
    let timelineEntryStateDone = TimelineEntryState.open.rawValue
    var count = 0

    let fetchDescriptor = FetchDescriptor<TimelineEntry>(
      predicate: #Predicate { $0.isDue <= tomorrow && $0.state == timelineEntryStateDone },
    )

    do {
      let entries = try context.fetch(fetchDescriptor)
      count = entries.count

      for entry in entries {
        entry.completedAt = entry.isDue
        entry.state = TimelineEntryState.done.rawValue
      }
      try context.save()
    } catch {
      print("Failed to tick entries: \(error)")
    }

    return count
  }
}
