// Created for BookingSense on 01.11.24 by kenny
// Using Swift 6.0

import Foundation

public enum TimelineEntryState: String, Codable, CaseIterable, Identifiable {
  public var id: Self { self }

  case open
  case done
  case skipped

  public var description: String {
    switch self {
    case .open: return String(localized: "Open", bundle: .module)
    case .done: return String(localized: "Done", bundle: .module)
    case .skipped: return String(localized: "Skipped", bundle: .module)
    }
  }
}
