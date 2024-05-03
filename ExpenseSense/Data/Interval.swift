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
        return String(localized: "daily")
      case .weekly:
        return String(localized: "weekly")
      case .biweekly:
        return String(localized: "biweekly")
      case .monthly:
        return String(localized: "monthly")
      case .quarterly:
        return String(localized: "quarterly")
      case .semiannually:
        return String(localized: "semiannually")
      case .annually:
        return String(localized: "annually")
      }
  }
}
