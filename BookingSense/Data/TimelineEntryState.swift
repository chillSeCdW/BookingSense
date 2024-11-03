// Created for BookingSense on 01.11.24 by kenny
// Using Swift 6.0

import Foundation

enum TimelineEntryState: String, Codable, CaseIterable, Identifiable {
  var id: Self { self }

  case active
  case done
  case skipped

  var description: String {
    switch self {
    case .active: return "Active"
    case .done: return "Done"
    case .skipped: return "Skipped"
    }
  }
}
