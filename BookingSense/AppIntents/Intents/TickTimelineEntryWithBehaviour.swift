// Created for BookingSense on 22.01.25 by kenny
// Using Swift 6.0

import Foundation
import OSLog
import AppIntents
import SwiftData
import WidgetKit
import BookingSenseData

private let logger = Logger(subsystem: "BookingSenseWidget", category: "CheckMarkTL")

struct TickTimelineEntryWithBehaviour: AppIntent {

  static var title: LocalizedStringResource = "Tick Timeline entry with behaviour"
  static var description = IntentDescription("Timeline entry will be completed on configured day")

  @Parameter(title: "Timeline Entry")
  var timelineEntryEntity: TimelineEntryEntity

  @Parameter(title: "Type of checking")
  var typeOfChecking: BookingSenseWidgetCheckBehaviour

  init(timelineEntryEntity: TimelineEntryEntity, typeOfChecking: BookingSenseWidgetCheckBehaviour) {
    self.timelineEntryEntity = timelineEntryEntity
    self.typeOfChecking = typeOfChecking
  }

  init() {}

  func perform() async throws -> some IntentResult {
    do {
      let context = ModelContext(DataModel.shared.modelContainer)
      let uuidOfTimelineEntryToUpdate = timelineEntryEntity.uuid
      let data = try context.fetch(
        FetchDescriptor<BookingSchemaV5.TimelineEntry>(
          predicate: #Predicate {
            $0.uuid == uuidOfTimelineEntryToUpdate
          },
          sortBy: [.init(\.isDue)]
        )
      )
      if let entry = data.first {
        entry.state = TimelineEntryState.done.rawValue
        switch typeOfChecking {
        case .onTime:
          entry.completedAt = entry.isDue
        case .today:
          entry.completedAt = Date()
        }
        try context.save()
        WidgetCenter.shared.reloadTimelines(ofKind: "BookingTimeWidget")
      }
    } catch {
      logger.error("\(error.localizedDescription)")
    }
    return .result()
  }
}
