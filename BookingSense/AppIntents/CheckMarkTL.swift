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
  static var description = IntentDescription("Timeline entry will be completed on current date")

  @Parameter(title: "UUID of TimelineEntry")
  var uuid: String

  init(uuid: String) {
    self.uuid = uuid
  }

  init() {}

  func perform() async throws -> some IntentResult {
    do {
      var context = ModelContext(DataModel.shared.modelContainer)
      var data = try context.fetch(
        FetchDescriptor<BookingSchemaV5.TimelineEntry>(
          predicate: #Predicate {
            $0.uuid == uuid
          },
          sortBy: [.init(\.isDue)]
        )
      )
      if let entry = data.first {
        entry.state = TimelineEntryState.done.rawValue
        entry.completedAt = Date()
        try context.save()
      }
    } catch {
      logger.error("\(error.localizedDescription)")
    }
    return .result()
  }
}
