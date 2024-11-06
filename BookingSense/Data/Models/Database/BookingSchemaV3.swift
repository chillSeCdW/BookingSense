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
    var name: String
    var state: String
    @Relationship var tag: Tag?
    @Relationship(deleteRule: .cascade) var timelineEntries: [TimelineEntry]?
    var amount: Decimal = Decimal.zero
    var date: Date = Date()
    var amountPrefix: String = "minus"
    var interval: String = "monthly"

    init(uuid: String = UUID().uuidString,
         name: String = "",
         state: String = "active",
         amount: Decimal,
         date: Date = Date(),
         amountPrefix: String = "minus",
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
      searchName: String
    ) -> Predicate<BookingEntry> {
      return #Predicate<BookingEntry> { entry in
        (searchName.isEmpty || entry.name.localizedStandardContains(searchName))
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
    var state: String = "active"
    var tag: Tag?
    var name: String = ""
    var amount: Decimal = Decimal.zero
    var amountPrefix: String = "minus"
    var isDue: Date = Date()
    var completedAt: Date?

    init(uuid: String = UUID().uuidString,
         state: String,
         name: String,
         amount: Decimal,
         amountPrefix: String,
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
      _ searchName: String,
      stateFilter: Set<TimelineEntryState>,
      amountPFilter: Set<AmountPrefix>
    ) -> Predicate<TimelineEntry> {
      let states = stateFilter.map { entry in
        entry.rawValue
      }
      let amountPrefix = amountPFilter.map { entry in
        entry.rawValue
      }

      return #Predicate<TimelineEntry> { entry in
        return (searchName.isEmpty || entry.name.contains(searchName))
        &&
        states.contains(entry.state)
        &&
        amountPrefix.contains(entry.amountPrefix)
      }
    }
  }
}
