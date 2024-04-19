//
//  ExpenseEntry.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 27.03.24.
//

import Foundation
import SwiftData

@Model
final class ExpenseEntry: Codable {
  enum CodingKeys: CodingKey {
    case id, name, amount, amountPrefix, interval
  }

  @Attribute(.unique)
  var id: String
  var name: String
  var amount: Decimal
  var amountPrefix: AmountPrefix
  var interval: Interval

  init(name: String, amount: Decimal, amountPrefix: AmountPrefix, interval: Interval) {
    self.id = UUID().uuidString
    self.name = name
    self.amount = amount
    self.amountPrefix = amountPrefix
    self.interval = interval
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    amount = try container.decode(Decimal.self, forKey: .amount)
    amountPrefix = try container.decode(AmountPrefix.self, forKey: .amountPrefix)
    interval = try container.decode(Interval.self, forKey: .interval)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(amount, forKey: .amount)
    try container.encode(amountPrefix, forKey: .amountPrefix)
    try container.encode(interval, forKey: .interval)
  }
}
