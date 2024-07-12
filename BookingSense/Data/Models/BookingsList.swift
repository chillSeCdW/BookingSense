// Created for BookingSense on 04.07.24 by kenny
// Using Swift 5.0

import Foundation

struct BookingsList: Codable {
  let data: [BookingEntry]

  init(_ data: [BookingEntry]) {
    self.data = data
  }
}
