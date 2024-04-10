//
//  interval.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 27.03.24.
//

import Foundation

enum Interval: Codable, CaseIterable, Identifiable {
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
        return "daily"
      case .weekly:
        return "weekly"
      case .biweekly:
        return "biweekly"
      case .monthly:
        return "monthly"
      case .quarterly:
        return "quarterly"
      case .semiannually:
        return "semiannually"
      case .annually:
        return "annually"
      }
  }
}
