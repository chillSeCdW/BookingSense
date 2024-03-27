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
    case name, amount, interval
  }
  
  var name: String
  var amount: Float
  var interval: Interval
    
  init(name: String, amount: Float, interval: Interval) {
    self.name = name
    self.amount = amount
    self.interval = interval
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    amount = try container.decode(Float.self, forKey: .amount)
    interval = try container.decode(Interval.self, forKey: .interval)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(amount, forKey: .amount)
    try container.encode(interval, forKey: .interval)
  }
}
