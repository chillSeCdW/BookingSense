//
//  ExpenseSchemaV1.swift
//  BookingSense
//
//  Created by kenny on 29.04.24.
//

import Foundation
import SwiftUI
import SwiftData

enum BookingSchemaV1: VersionedSchema {
  static var models: [any PersistentModel.Type] {
    [
      BookingEntry.self
    ]
  }

  static var versionIdentifier: Schema.Version = .init(1, 0, 0)

}

extension BookingSchemaV1 {

  enum CodingKeys: CodingKey {
    case id, name, tags, amount, amountPrefix, interval, intervalString
  }

  @Model
  final class BookingEntry: Codable {

    var id: String
    var name: String
    var tags: [String]
    var amount: Decimal
    var amountPrefix: AmountPrefix
    var interval: String

    init(name: String, tags: [String], amount: Decimal, amountPrefix: AmountPrefix, interval: Interval) {
      self.id = UUID().uuidString
      self.name = name
      self.tags = tags
      self.amount = amount
      self.amountPrefix = amountPrefix
      self.interval = interval.rawValue
    }

    required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = try container.decode(String.self, forKey: .id)
      name = try container.decode(String.self, forKey: .name)
      tags = try container.decode([String].self, forKey: .tags)
      amount = try container.decode(Decimal.self, forKey: .amount)
      amountPrefix = try container.decode(AmountPrefix.self, forKey: .amountPrefix)
      interval = try container.decode(String.self, forKey: .interval)
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(name, forKey: .name)
      try container.encode(tags, forKey: .tags)
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
}
