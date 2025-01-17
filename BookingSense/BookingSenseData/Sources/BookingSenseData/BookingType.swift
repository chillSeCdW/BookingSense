//
//  BookingType.swift
//  BookingSense
//
//  Created by kenny on 10.04.24.
//

import Foundation

public enum BookingType: String, Codable, CaseIterable, Identifiable {
  public var id: Self { self }

  case plus
  case minus
  case saving

  public var description: String {
    switch self {
    case .plus:
      return String(localized: "Incoming", bundle: .module)
    case .minus:
      return String(localized: "Outgoing", bundle: .module)
    case .saving:
      return String(localized: "Saving", bundle: .module)
    }
  }
}
