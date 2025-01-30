//
//  ExpenseSchemaV1.swift
//  BookingSense
//
//  Created by kenny on 29.04.24.
//

import Foundation
import SwiftUI
import SwiftData

public enum BookingSchemaV1: VersionedSchema {
  public static var models: [any PersistentModel.Type] {
    [
      BookingEntry.self
    ]
  }

  public nonisolated(unsafe) static var versionIdentifier: Schema.Version = .init(1, 0, 0)

}

extension BookingSchemaV1 {

  enum CodingKeys: CodingKey {
    case id, name, tags, amount, amountPrefix, interval, intervalString
  }

  @Model
  public final class BookingEntry: Codable {

    public var id: String
    public var name: String
    public var tags: [String]
    public var amount: Decimal
    public var amountPrefix: BookingType
    public var interval: String

    init(name: String, tags: [String], amount: Decimal, amountPrefix: BookingType, interval: Interval) {
      self.id = UUID().uuidString
      self.name = name
      self.tags = tags
      self.amount = amount
      self.amountPrefix = amountPrefix
      self.interval = interval.rawValue
    }

    public required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = try container.decode(String.self, forKey: .id)
      name = try container.decode(String.self, forKey: .name)
      tags = try container.decode([String].self, forKey: .tags)
      amount = try container.decode(Decimal.self, forKey: .amount)
      amountPrefix = try container.decode(BookingType.self, forKey: .amountPrefix)
      interval = try container.decode(String.self, forKey: .interval)
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(name, forKey: .name)
      try container.encode(tags, forKey: .tags)
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

    static func totalExpenseEntries(modelContext: ModelContext) -> Int {
      (try? modelContext.fetchCount(FetchDescriptor<BookingEntry>())) ?? 0
    }
  }
}
