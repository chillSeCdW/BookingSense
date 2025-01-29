// Created for BookingSense on 22.01.25 by kenny
// Using Swift 6.0

import Foundation
import OSLog
import AppIntents
import SwiftData
import WidgetKit
import BookingSenseData

private let logger = Logger(subsystem: "BookingSenseWidget", category: "CheckMarkTL")

struct CheckMarkTL: AppIntent {

  static var title: LocalizedStringResource = "Checkmark Timeline entry"
  static var description = IntentDescription("Timeline entry will be completed on configured day")

  @Parameter(title: "UUID of TimelineEntry")
  var uuid: String

  @Parameter(title: "Type of checking")
  var typeOfChecking: BookingSenseWidgetCheckBehaviour

  init(uuid: String, typeOfChecking: BookingSenseWidgetCheckBehaviour) {
    self.uuid = uuid
    self.typeOfChecking = typeOfChecking
  }

  init() {}

  func perform() async throws -> some IntentResult {
    do {
      let context = ModelContext(DataModel.shared.modelContainer)
      let data = try context.fetch(
        FetchDescriptor<BookingSchemaV5.TimelineEntry>(
          predicate: #Predicate {
            $0.uuid == uuid
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
