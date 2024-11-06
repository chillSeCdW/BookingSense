// Created for BookingSense on 01.11.24 by kenny
// Using Swift 6.0

import Foundation

enum BookingEntryState: String, Codable, CaseIterable, Identifiable {
  var id: Self { self }

  case active
  case paused
  case archived

  var description: String {
    switch self {
    case .active: return String(localized: "Active")
    case .paused: return String(localized: "Paused")
    case .archived: return String(localized: "Archived")
    }
  }
}
