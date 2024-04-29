//
//  ExpenseSchemaV1.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 29.04.24.
//

import Foundation
import SwiftData

enum ExpenseSchemaV1: VersionedSchema {
  static var models: [any PersistentModel.Type] {
    [
      ExpenseEntry.self
    ]
  }

  static var versionIdentifier: Schema.Version = .init(1, 0, 0)

}

extension ExpenseSchemaV1 {

  enum CodingKeys: CodingKey {
    case id, name, amount, amountPrefix, interval, intervalString
  }

  @Model
  final class ExpenseEntry: Codable {

    @Attribute(.unique)
    var id: String
    var name: String
    var amount: Decimal
    var amountPrefix: AmountPrefix
    var interval: String

    init(name: String, amount: Decimal, amountPrefix: AmountPrefix, interval: Interval) {
      self.id = UUID().uuidString
      self.name = name
      self.amount = amount
      self.amountPrefix = amountPrefix
      self.interval = interval.rawValue
    }

    required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = try container.decode(String.self, forKey: .id)
      name = try container.decode(String.self, forKey: .name)
      amount = try container.decode(Decimal.self, forKey: .amount)
      amountPrefix = try container.decode(AmountPrefix.self, forKey: .amountPrefix)
      interval = try container.decode(String.self, forKey: .interval)
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(name, forKey: .name)
      try container.encode(amount, forKey: .amount)
      try container.encode(amountPrefix, forKey: .amountPrefix)
      try container.encode(interval, forKey: .interval)
    }

    static func predicate(
        searchName: String,
        interval: Interval
    ) -> Predicate<ExpenseEntry> {
        return #Predicate<ExpenseEntry> { entry in
          (searchName.isEmpty || entry.name.contains(searchName))
          &&
          (entry.interval == interval.rawValue)
        }
    }

    static func totalExpenseEntries(modelContext: ModelContext) -> Int {
        (try? modelContext.fetchCount(FetchDescriptor<ExpenseEntry>())) ?? 0
    }
  }
}
