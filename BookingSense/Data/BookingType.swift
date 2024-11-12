//
//  BookingType.swift
//  BookingSense
//
//  Created by kenny on 10.04.24.
//

import Foundation

enum BookingType: String, Codable, CaseIterable, Identifiable {
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
