// Created for BookingSense on 15.06.25 by kenny
// Using Swift 6.0

import AppIntents
import SwiftData
import BookingSenseData

struct BookingEntryEntity: AppEntity {
  static var typeDisplayRepresentation: TypeDisplayRepresentation = "Booking Entry"
  static var defaultQuery = BookingEntryQuery()

  var displayRepresentation: DisplayRepresentation {
    DisplayRepresentation(
      title: "\(name), \(interval.description)",
      subtitle: "\(amount.generateFormattedCurrency()), \(bookingType.description)"
    )
  }

  var id: String { uuid }

  var uuid: String
  var name: String
  var state: BookingEntryState
  var amount: Decimal
  var date: Date?
  var bookingType: BookingType
  var interval: Interval
  var dayOfEntry: Int
  var tagName: String?

  init(from model: BookingSchemaV5.BookingEntry) {
    self.uuid = model.uuid
    self.name = model.name
    self.state = BookingEntryState(rawValue: model.state) ?? BookingEntryState.active
    self.amount = model.amount
    self.date = model.date
    self.bookingType = BookingType(rawValue: model.bookingType) ?? BookingType.minus
    self.interval = Interval(rawValue: model.interval) ?? Interval.monthly
    self.dayOfEntry = model.dayOfEntry
    self.tagName = model.tag?.name
  }
}

struct BookingEntryQuery: EntityQuery {
  func entities(for identifiers: [String]) async throws -> [BookingEntryEntity] {
    let context = ModelContext(DataModel.shared.modelContainer)
    let entries = try context.fetch(
      FetchDescriptor<BookingSchemaV5.BookingEntry>(
        predicate: #Predicate { identifiers.contains($0.uuid) }
      )
    )
    return entries.map { BookingEntryEntity(from: $0) }
  }

  func suggestedEntities() async throws -> [BookingEntryEntity] {
    let context = ModelContext(DataModel.shared.modelContainer)
    let entries = try context.fetch(
      FetchDescriptor<BookingSchemaV5.BookingEntry>(
        sortBy: [SortDescriptor(\.name, order: .forward)]
      )
    )
    return entries.map { BookingEntryEntity(from: $0) }
  }
}
