// Created for BookingSense on 13.11.24 by kenny
// Using Swift 6.0

import Foundation

enum AmountPrefix: Codable, CaseIterable, Identifiable {
  var id: Self { self }

  case plus
  case minus
  case saving

  var description: String {
    switch self {
    case .plus:
      return String(localized: "Incoming")
    case .minus:
      return String(localized: "Outgoing")
    case .saving:
      return String(localized: "Saving")
    }
  }
}
