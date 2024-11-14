// Created for BookingSense on 30.10.24 by kenny
// Using Swift 6.0

import Foundation

enum JsonBookingEntryKeys: CodingKey {
  case uuid, name, state, amount, date, bookingType, interval, intervalString, tag, timelineEntries
}

class JsonBookingEntry: Codable {

  var uuid: String = UUID().uuidString
  var name: String = ""
  var state: String = "active"
  var tag: String?
  var timelineEntries: [String]?
  var amount: Decimal = Decimal.zero
  var date: Date?
  var bookingType: String = "minus"
  var interval: String = "monthly"

  init(name: String,
       state: String,
       amount: Decimal,
       date: Date = Date(),
       bookingType: String,
       interval: Interval,
       tag: String?,
       timelineEntries: [String]?) {
    self.name = name
    self.state = state
    self.date = date
    self.amount = amount
    self.bookingType = bookingType
    self.interval = interval.rawValue
    self.tag = tag
    self.timelineEntries = timelineEntries
  }

  init(_ data: BookingEntry) {
    self.uuid = data.uuid
    self.name = data.name
    self.state = data.state
    self.date = data.date
    self.amount = data.amount
    self.bookingType = data.bookingType
    self.interval = data.interval
    self.tag = data.tag?.uuid
    self.timelineEntries = data.timelineEntries?.map { $0.uuid }
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: JsonBookingEntryKeys.self)
    uuid = try container.decode(String.self, forKey: .uuid)
    name = try container.decode(String.self, forKey: .name)
    state = try container.decode(String.self, forKey: .state)
    date = try container.decode(Date.self, forKey: .date)
    amount = try container.decode(Decimal.self, forKey: .amount)
    bookingType = try container.decode(String.self, forKey: .bookingType)
    interval = try container.decode(String.self, forKey: .interval)
    tag = try container.decodeIfPresent(String.self, forKey: .tag)
    timelineEntries = try container.decodeIfPresent([String].self, forKey: .timelineEntries)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: JsonBookingEntryKeys.self)
    try container.encode(uuid, forKey: .uuid)
    try container.encode(name, forKey: .name)
    try container.encode(state, forKey: .state)
    try container.encode(date, forKey: .date)
    try container.encode(amount, forKey: .amount)
    try container.encode(bookingType, forKey: .bookingType)
    try container.encode(interval, forKey: .interval)
    try container.encode(tag, forKey: .tag)
    try container.encode(timelineEntries, forKey: .timelineEntries)
  }
}
