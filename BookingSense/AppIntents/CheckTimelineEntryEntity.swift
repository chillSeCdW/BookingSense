// Created for BookingSense on 15.06.25 by kenny
// Using Swift 6.0

import Foundation
import OSLog
import AppIntents
import SwiftData
import WidgetKit
import BookingSenseData

private let logger = Logger(subsystem: "BookingSenseWidget", category: "CheckTimelineEntryEntity")

struct CheckTimelineEntryEntity: AppIntent {

  static var title: LocalizedStringResource = "Check Timeline entry"
  static var description = IntentDescription("Will tick timeline entry to done")

  @Parameter(title: "Timeline Entry")
  var timelineEntryEntity: TimelineEntryEntity

  func perform() async throws -> some IntentResult {
    let context = ModelContext(DataModel.shared.modelContainer)
    let entityUUID = timelineEntryEntity.uuid

    do {
      let entries = try context.fetch(
        FetchDescriptor<BookingSchemaV5.TimelineEntry>(
          predicate: #Predicate {
            $0.uuid == entityUUID
          },
          sortBy: [.init(\.isDue)]
        )
      )
      if let entry = entries.first {
        entry.state = TimelineEntryState.done.rawValue
        entry.completedAt = Date()
        try context.save()
        WidgetCenter.shared.reloadTimelines(ofKind: "BookingTimeWidget")
      }
      return .result()
    } catch {
      logger.error("\(error.localizedDescription)")
      return .result()
    }
  }
}
