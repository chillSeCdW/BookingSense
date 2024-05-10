//
//  interval.swift
//  BookingSense
//
//  Created by kenny on 27.03.24.
//

import Foundation

enum Interval: String, Codable, CaseIterable, Identifiable {
  var id: Self { self }

  case daily
  case weekly
  case biweekly
  case monthly
  case quarterly
  case semiannually
  case annually

  var description: String {
      switch self {
      case .daily:
        return String(localized: "Daily")
      case .weekly:
        return String(localized: "Weekly")
      case .biweekly:
        return String(localized: "Biweekly")
      case .monthly:
        return String(localized: "Monthly")
      case .quarterly:
        return String(localized: "Quarterly")
      case .semiannually:
        return String(localized: "Semiannually")
      case .annually:
        return String(localized: "Annually")
      }
  }
}
