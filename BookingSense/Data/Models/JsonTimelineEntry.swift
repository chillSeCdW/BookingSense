// Created for BookingSense on 30.10.24 by kenny
// Using Swift 6.0

import Foundation
import BookingSenseData

enum TimelineEntryKeys: CodingKey {
  case uuid, bookingEntry, state, name, tag, amount, bookingType, isDue, completedAt
}

class JsonTimelineEntry: Codable {

  var uuid: String = UUID().uuidString
  var bookingEntry: String?
  var state: String = "open"
  var name: String = ""
  var tag: String?
  var amount: Decimal = Decimal.zero
  var bookingType: String = "minus"
  var isDue: Date = Date()
  var completedAt: Date?

  init(state: String,
       name: String,
       tag: String?,
       amount: Decimal,
       bookingType: String,
       isDue: Date,
       completedAt: Date?) {
    self.state = state
    self.name = name
    self.tag = tag
    self.amount = amount
    self.bookingType = bookingType
    self.isDue = isDue
    self.completedAt = completedAt
  }

  init(_ data: TimelineEntry) {
    self.uuid = data.uuid
    self.bookingEntry = data.bookingEntry?.uuid
    self.state = data.state
    self.name = data.name
    self.tag = data.tag?.uuid
    self.amount = data.amount
    self.bookingType = data.bookingType
    self.isDue = data.isDue
    self.completedAt = data.completedAt
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: TimelineEntryKeys.self)
    uuid = try container.decode(String.self, forKey: .uuid)
    bookingEntry = try container.decodeIfPresent(String.self, forKey: .bookingEntry)
    state = try container.decode(String.self, forKey: .state)
    name = try container.decode(String.self, forKey: .name)
    tag = try container.decodeIfPresent(String.self, forKey: .tag)
    amount = try container.decode(Decimal.self, forKey: .amount)
    bookingType = try container.decode(String.self, forKey: .bookingType)
    isDue = try container.decode(Date.self, forKey: .isDue)
    completedAt = try container.decodeIfPresent(Date.self, forKey: .completedAt)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: TimelineEntryKeys.self)
    try container.encode(uuid, forKey: .uuid)
    try container.encode(bookingEntry, forKey: .bookingEntry)
    try container.encode(state, forKey: .state)
    try container.encode(name, forKey: .name)
    try container.encode(tag, forKey: .tag)
    try container.encode(amount, forKey: .amount)
    try container.encode(bookingType, forKey: .bookingType)
    try container.encode(isDue, forKey: .isDue)
    try container.encode(completedAt, forKey: .completedAt)
  }
}
