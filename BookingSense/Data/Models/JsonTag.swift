// Created for BookingSense on 30.10.24 by kenny
// Using Swift 6.0

import Foundation

enum TagKeys: CodingKey {
  case uuid, name, bookingEntry
}

class JsonTag: Codable {

  var uuid: String = UUID().uuidString
  var name: String = ""
  var bookingEntries: [String]?

  init(_ name: String) {
    self.name = name
  }

  init (_ data: Tag) {
    self.uuid = data.uuid
    self.name = data.name
    self.bookingEntries = data.bookingEntries?.map {
      $0.uuid
    }
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: TagKeys.self)
    uuid = try container.decode(String.self, forKey: .uuid)
    name = try container.decode(String.self, forKey: .name)
    bookingEntries = try container.decodeIfPresent([String].self, forKey: .bookingEntry)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: TagKeys.self)
    try container.encode(uuid, forKey: .uuid)
    try container.encode(name, forKey: .name)
    try container.encode(bookingEntries, forKey: .bookingEntry)
  }
}