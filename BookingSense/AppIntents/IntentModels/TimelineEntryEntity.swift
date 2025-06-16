// Created for BookingSense on 15.06.25 by kenny
// Using Swift 6.0

import AppIntents
import SwiftData
import BookingSenseData

struct TimelineEntryEntity: AppEntity {
  static var typeDisplayRepresentation: TypeDisplayRepresentation = "Timeline Entry"
  static var defaultQuery = TimelineEntryEntityQuery()

  var displayRepresentation: DisplayRepresentation {
    DisplayRepresentation(
      title: "\(name)",
      subtitle: "\(isDue.timelineEntryFormatting())"
    )
  }

  var id: String { uuid }

  var uuid: String
  var state: TimelineEntryState
  var name: String
  var amount: Decimal
  var bookingType: BookingType
  var isDue: Date
  var completedAt: Date?
  var tagName: String?
  var bookingEntryName: String?

  init(uuid: String,
       state: TimelineEntryState,
       name: String,
       amount: Decimal,
       bookingType: BookingType,
       isDue: Date,
       completedAt: Date? = nil,
       tagName: String? = nil,
       bookingEntryName: String? = nil
  ) {
    self.uuid = uuid
    self.state = state
    self.name = name
    self.amount = amount
    self.bookingType = bookingType
    self.isDue = isDue
    self.completedAt = completedAt
    self.tagName = tagName
    self.bookingEntryName = bookingEntryName
  }

  init(from model: BookingSchemaV5.TimelineEntry) {
    self.uuid = model.uuid
    self.state = TimelineEntryState(rawValue: model.state) ?? TimelineEntryState.open
    self.name = model.name
    self.amount = model.amount
    self.bookingType = BookingType(rawValue: model.bookingType) ?? BookingType.minus
    self.isDue = model.isDue
    self.completedAt = model.completedAt
    self.tagName = model.tag?.name
    self.bookingEntryName = model.bookingEntry?.name
  }
}

struct TimelineEntryEntityQuery: EntityQuery {
  func entities(for identifiers: [String]) async throws -> [TimelineEntryEntity] {
    let context = ModelContext(DataModel.shared.modelContainer)
    let entries = try context.fetch(
      FetchDescriptor<BookingSchemaV5.TimelineEntry>(
        predicate: #Predicate { identifiers.contains($0.uuid) }
      )
    )
    return entries.map { TimelineEntryEntity(from: $0) }
  }

  func suggestedEntities() async throws -> [TimelineEntryEntity] {
    let context = ModelContext(DataModel.shared.modelContainer)
    let descriptor = FetchDescriptor<BookingSchemaV5.TimelineEntry>(
      sortBy: [.init(\.isDue)]
    )

    let entries = try context.fetch(descriptor)
    return entries.map { TimelineEntryEntity(from: $0) }
  }
}
