// Created for BookingSense on 01.11.24 by kenny
// Using Swift 6.0

import Foundation

enum TimelineEntryState: String, Codable, CaseIterable, Identifiable {
  var id: Self { self }

  case open
  case done
  case skipped

  var description: String {
    switch self {
    case .open: return String(localized: "Open")
    case .done: return String(localized: "Done")
    case .skipped: return String(localized: "Skipped")
    }
  }
}
