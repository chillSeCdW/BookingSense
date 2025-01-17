//
//  ExpenseSchemaV1.swift
//  BookingSense
//
//  Created by kenny on 29.04.24.
//

import Foundation
import SwiftUI
import SwiftData

public enum BookingSchemaV2: VersionedSchema {
  public static var models: [any PersistentModel.Type] {
    [
      BookingEntry.self,
      Tag.self
    ]
  }

  public nonisolated(unsafe) static var versionIdentifier: Schema.Version = .init(1, 1, 0)

}

extension BookingSchemaV2 {

  enum BookingEntryKeys: CodingKey {
    case id, name, tag, amount, date, amountPrefix, interval, intervalString
  }

  enum TagKeys: CodingKey {
    case id, name
  }

  @Model
  public final class BookingEntry: Codable {

    public var id: String = UUID().uuidString
    public var name: String = ""
    public var isActive: Bool = true
    @Relationship public var tag: Tag?
    public var amount: Decimal = Decimal.zero
    public var date: Date = Date()
    public var amountPrefix: AmountPrefix = AmountPrefix.minus
    public var interval: String = "monthly"

    public init(
      name: String,
      isActive: Bool = true,
      tag: Tag?,
      amount: Decimal,
      date: Date = Date(),
      amountPrefix: AmountPrefix,
      interval: Interval) {
        self.name = name
        self.isActive = isActive
        self.tag = tag
        self.date = date
        self.amount = amount
        self.amountPrefix = amountPrefix
        self.interval = interval.rawValue
      }

    public required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: BookingEntryKeys.self)
      id = try container.decode(String.self, forKey: .id)
      name = try container.decode(String.self, forKey: .name)
      tag = try container.decodeIfPresent(Tag.self, forKey: .tag)
      date = try container.decode(Date.self, forKey: .date)
      amount = try container.decode(Decimal.self, forKey: .amount)
      amountPrefix = try container.decode(AmountPrefix.self, forKey: .amountPrefix)
      interval = try container.decode(String.self, forKey: .interval)
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: BookingEntryKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(name, forKey: .name)
      try container.encode(tag, forKey: .tag)
      try container.encode(date, forKey: .date)
      try container.encode(amount, forKey: .amount)
      try container.encode(amountPrefix, forKey: .amountPrefix)
      try container.encode(interval, forKey: .interval)
    }

    public static func predicate(
      searchName: String,
      interval: Interval
    ) -> Predicate<BookingEntry> {
      return #Predicate<BookingEntry> { entry in
        (searchName.isEmpty || entry.name.contains(searchName))
        &&
        (entry.interval == interval.rawValue)
      }
    }

    public static func totalExpenseEntries(modelContext: ModelContext) -> Int {
      (try? modelContext.fetchCount(FetchDescriptor<BookingEntry>())) ?? 0
    }
  }

  @Model
  public final class Tag: Codable {

    public var id: String = UUID().uuidString
    public var name: String = ""
    @Relationship(inverse: \BookingEntry.tag) public var bookingEntry: [BookingEntry]?

    public init(_ name: String) {
      self.name = name
    }

    public required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: TagKeys.self)
      id = try container.decode(String.self, forKey: .id)
      name = try container.decode(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: TagKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(name, forKey: .name)
    }
  }
}
