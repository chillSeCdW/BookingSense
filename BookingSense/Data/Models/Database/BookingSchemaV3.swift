// Created for BookingSense on 30.10.24 by kenny
// Using Swift 6.0

import Foundation
import SwiftUI
import SwiftData

enum BookingSchemaV3: VersionedSchema {
  static var models: [any PersistentModel.Type] {
    [
      BookingEntry.self,
      Tag.self,
      TimelineEntry.self
    ]
  }

  static var versionIdentifier: Schema.Version = .init(1, 2, 0)

}

extension BookingSchemaV3 {

  @Model
  final class BookingEntry {

    var uuid: String
    var name: String = ""
    var state: BookingEntryState
    @Relationship var tag: Tag?
    @Relationship(deleteRule: .cascade) var timelineEntries: [TimelineEntry]?
    var amount: Decimal = Decimal.zero
    var date: Date = Date()
    var amountPrefix: AmountPrefix = AmountPrefix.minus
    var interval: String = "monthly"

    init(uuid: String = UUID().uuidString,
         name: String,
         state: BookingEntryState = .active,
         amount: Decimal,
         date: Date = Date(),
         amountPrefix: AmountPrefix,
         interval: Interval,
         tag: Tag?,
         timelineEntries: [TimelineEntry]?) {
      self.uuid = uuid
      self.name = name
      self.state = state
      self.date = date
      self.amount = amount
      self.amountPrefix = amountPrefix
      self.interval = interval.rawValue
      self.tag = tag
      self.timelineEntries = timelineEntries
    }

    static func predicate(
      searchName: String,
      interval: Interval
    ) -> Predicate<BookingEntry> {
      return #Predicate<BookingEntry> { entry in
        (searchName.isEmpty || entry.name.contains(searchName))
        &&
        (entry.interval == interval.rawValue)
      }
    }

    static func totalExpenseEntries(modelContext: ModelContext) -> Int {
      (try? modelContext.fetchCount(FetchDescriptor<BookingEntry>())) ?? 0
    }
  }

  @Model
  final class Tag {

    var uuid: String
    var name: String = ""
    @Relationship(inverse: \BookingEntry.tag) var bookingEntries: [BookingEntry]?

    init(uuid: String = UUID().uuidString, name: String) {
      self.uuid = uuid
      self.name = name
    }
  }

  @Model
  final class TimelineEntry: ObservableObject, Identifiable {

    var uuid: String
    @Relationship(inverse: \BookingEntry.timelineEntries) var bookingEntry: BookingEntry?
    var state: TimelineEntryState = TimelineEntryState.active
    var tag: Tag?
    var name: String = ""
    var amount: Decimal = Decimal.zero
    var amountPrefix: AmountPrefix = AmountPrefix.minus
    var isDue: Date = Date()
    var completedAt: Date?

    init(uuid: String = UUID().uuidString,
         state: TimelineEntryState,
         name: String,
         amount: Decimal,
         amountPrefix: AmountPrefix,
         isDue: Date,
         tag: Tag?,
         completedAt: Date?,
         bookingEntry: BookingEntry?
    ) {
      self.uuid = uuid
      self.bookingEntry = bookingEntry
      self.state = state
      self.name = name
      self.amount = amount
      self.amountPrefix = amountPrefix
      self.isDue = isDue
      self.tag = tag
      self.completedAt = completedAt
    }

    static func predicate(
      _ searchName: String
    ) -> Predicate<TimelineEntry> {
      return #Predicate<TimelineEntry> { entry in
        return (searchName.isEmpty || entry.name.contains(searchName))
      }
    }
  }
}
