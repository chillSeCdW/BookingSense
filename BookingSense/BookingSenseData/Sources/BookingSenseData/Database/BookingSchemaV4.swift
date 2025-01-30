// Created for BookingSense on 30.10.24 by kenny
// Using Swift 6.0

import Foundation
import SwiftUI
import SwiftData

public enum BookingSchemaV4: VersionedSchema {
  public static var models: [any PersistentModel.Type] {
    [
      BookingEntry.self,
      Tag.self,
      TimelineEntry.self
    ]
  }

  public nonisolated(unsafe) static var versionIdentifier: Schema.Version = .init(1, 3, 0)

}

extension BookingSchemaV4 {

  @Model
  public final class BookingEntry {

    public var uuid: String = UUID().uuidString
    public var name: String = ""
    public var state: String = "active"
    @Relationship public var tag: Tag?
    @Relationship(deleteRule: .cascade) public var timelineEntries: [TimelineEntry]?
    public var amount: Decimal = Decimal.zero
    public var date: Date?
    public var bookingType: String = "minus"
    public var interval: String = "monthly"

    public init(
      uuid: String = UUID().uuidString,
      name: String = "",
      state: String = "active",
      amount: Decimal,
      date: Date? = nil,
      bookingType: String = "minus",
      interval: Interval,
      tag: Tag?,
      timelineEntries: [TimelineEntry]?) {
        self.uuid = uuid
        self.name = name
        self.state = state
        self.date = date
        self.amount = amount
        self.bookingType = bookingType
        self.interval = interval.rawValue
        self.tag = tag
        self.timelineEntries = timelineEntries
      }

    public static func predicate(
      searchName: String,
      stateFilter: Set<BookingEntryState>,
      typeFilter: Set<BookingType>
    ) -> Predicate<BookingEntry> {
      let states = stateFilter.map { entry in
        entry.rawValue
      }
      let bookingType = typeFilter.map { entry in
        entry.rawValue
      }

      return #Predicate<BookingEntry> { entry in
        return (searchName.isEmpty || entry.name.localizedStandardContains(searchName))
        &&
        states.contains(entry.state)
        &&
        bookingType.contains(entry.bookingType)
      }
    }

    public static func totalExpenseEntries(modelContext: ModelContext) -> Int {
      (try? modelContext.fetchCount(FetchDescriptor<BookingEntry>())) ?? 0
    }

    public func getNextBookingDate() -> Date? {
      let latestEntry = self.timelineEntries?.filter { entry in
        entry.bookingEntry?.uuid == self.uuid && entry.state == TimelineEntryState.open.rawValue
      }.sorted(by: { $0.isDue < $1.isDue })

      if let bookDate = self.date {
        if let entry = latestEntry?.first {
          return entry.isDue
        }
        return bookDate
      }
      return nil
    }
  }

  @Model
  public final class Tag {

    public var uuid: String = UUID().uuidString
    public var name: String = ""
    @Relationship(inverse: \BookingEntry.tag) public var bookingEntries: [BookingEntry]?
    @Relationship(inverse: \TimelineEntry.tag) public var timelineEntries: [TimelineEntry]?

    public init(uuid: String = UUID().uuidString, name: String) {
      self.uuid = uuid
      self.name = name
    }
  }

  @Model
  public final class TimelineEntry: ObservableObject, Identifiable {

    public var uuid: String = UUID().uuidString
    @Relationship(inverse: \BookingEntry.timelineEntries) public var bookingEntry: BookingEntry?
    public var state: String = "active"
    @Relationship public var tag: Tag?
    public var name: String = ""
    public var amount: Decimal = Decimal.zero
    public var bookingType: String = "minus"
    public var isDue: Date = Date()
    public var completedAt: Date?

    public init(
      uuid: String = UUID().uuidString,
      state: String,
      name: String,
      amount: Decimal,
      bookingType: String,
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
      self.bookingType = bookingType
      self.isDue = isDue
      self.tag = tag
      self.completedAt = completedAt
    }

    public static func predicate(
      _ searchName: String,
      stateFilter: Set<TimelineEntryState>,
      typeFilter: Set<BookingType>
    ) -> Predicate<TimelineEntry> {
      let states = stateFilter.map { entry in
        entry.rawValue
      }
      let bookingType = typeFilter.map { entry in
        entry.rawValue
      }

      return #Predicate<TimelineEntry> { entry in
        return (searchName.isEmpty || entry.name.localizedStandardContains(searchName))
        &&
        (states.isEmpty || states.contains(entry.state))
        &&
        (bookingType.isEmpty || bookingType.contains(entry.bookingType))
      }
    }
  }
}
