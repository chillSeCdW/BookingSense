//
//  ExpenseSchemaV1.swift
//  BookingSense
//
//  Created by kenny on 29.04.24.
//

import Foundation
import SwiftUI
import SwiftData

enum BookingSchemaV2: VersionedSchema {
  static var models: [any PersistentModel.Type] {
    [
      BookingEntry.self
    ]
  }

  static var versionIdentifier: Schema.Version = .init(1, 1, 0)

}

extension BookingSchemaV2 {

  enum BookingEntryKeys: CodingKey {
    case id, name, tag, amount, date, amountPrefix, interval, intervalString
  }

  enum TagKeys: CodingKey {
    case id, name
  }

  @Model
  final class BookingEntry: Codable {

    var id: String = UUID().uuidString
    var name: String = ""
    var isActive: Bool = true
    @Relationship var tag: Tag?
    var amount: Decimal = Decimal.zero
    var date: Date = Date()
    var amountPrefix: BookingType = BookingType.minus
    var interval: String = "monthly"

    init(name: String,
         isActive: Bool = true,
         tag: Tag?,
         amount: Decimal,
         date: Date = Date(),
         amountPrefix: BookingType,
         interval: Interval) {
      self.name = name
      self.isActive = isActive
      self.tag = tag
      self.date = date
      self.amount = amount
      self.amountPrefix = amountPrefix
      self.interval = interval.rawValue
    }

    required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: BookingEntryKeys.self)
      id = try container.decode(String.self, forKey: .id)
      name = try container.decode(String.self, forKey: .name)
      tag = try container.decodeIfPresent(Tag.self, forKey: .tag)
      date = try container.decode(Date.self, forKey: .date)
      amount = try container.decode(Decimal.self, forKey: .amount)
      amountPrefix = try container.decode(BookingType.self, forKey: .amountPrefix)
      interval = try container.decode(String.self, forKey: .interval)
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: BookingEntryKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(name, forKey: .name)
      try container.encode(tag, forKey: .tag)
      try container.encode(date, forKey: .date)
      try container.encode(amount, forKey: .amount)
      try container.encode(amountPrefix, forKey: .amountPrefix)
      try container.encode(interval, forKey: .interval)
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
  final class Tag: Codable {

    var id: String = UUID().uuidString
    var name: String = ""
    @Relationship(inverse: \BookingEntry.tag) var bookingEntry: [BookingEntry]?

    init(_ name: String) {
      self.name = name
    }

    required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: TagKeys.self)
      id = try container.decode(String.self, forKey: .id)
      name = try container.decode(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: TagKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(name, forKey: .name)
    }
  }
}
