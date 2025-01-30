// Created for BookingSense on 01.11.24 by kenny
// Using Swift 6.0

import Foundation

public enum BookingEntryState: String, Codable, CaseIterable, Identifiable {
  public var id: Self { self }

  case active
  case paused
  case archived

  public var description: String {
    switch self {
    case .active: return String(localized: "Active", bundle: .module)
    case .paused: return String(localized: "Paused", bundle: .module)
    case .archived: return String(localized: "Archived", bundle: .module)
    }
  }
}
