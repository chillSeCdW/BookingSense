// Created for BookingSense on 30.10.24 by kenny
// Using Swift 6.0

import Foundation

enum TimelineEntryKeys: CodingKey {
  case uuid, bookingEntry, isDone, isDue, completedAt
}

class JsonTimelineEntry: Codable {

  var uuid: String = UUID().uuidString
  var bookingEntry: String?
  var isDone: Bool = false
  var isDue: Date = Date()
  var completedAt: Date?

  init(forDate: Date, isDone: Bool, isDue: Date, completedAt: Date?) {
    self.isDone = isDone
    self.isDue = isDue
    self.completedAt = completedAt
  }

  init(_ data: TimelineEntry) {
    self.uuid = data.uuid
    self.bookingEntry = data.bookingEntry?.uuid
    self.isDone = data.isDone
    self.isDue = data.isDue
    self.completedAt = data.completedAt
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: TimelineEntryKeys.self)
    uuid = try container.decode(String.self, forKey: .uuid)
    bookingEntry = try container.decodeIfPresent(String.self, forKey: .bookingEntry)
    isDone = try container.decode(Bool.self, forKey: .isDone)
    isDue = try container.decode(Date.self, forKey: .isDue)
    completedAt = try container.decodeIfPresent(Date.self, forKey: .completedAt)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: TimelineEntryKeys.self)
    try container.encode(uuid, forKey: .uuid)
    try container.encode(bookingEntry, forKey: .bookingEntry)
    try container.encode(isDone, forKey: .isDone)
    try container.encode(isDue, forKey: .isDue)
    try container.encode(completedAt, forKey: .completedAt)
  }
}
