// Created for BookingSense on 01.11.24 by kenny
// Using Swift 6.0

import Foundation

enum BookingEntryState: Codable, CaseIterable, Identifiable {
  var id: Self { self }

  case active
  case paused
  case archived

  var description: String {
    switch self {
    case .active: return "Active"
    case .paused: return "Paused"
    case .archived: return "Archived"
    }
  }
}
