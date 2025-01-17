//
//  interval.swift
//  BookingSense
//
//  Created by kenny on 27.03.24.
//

import Foundation

public enum Interval: String, Codable, CaseIterable, Identifiable {
  public var id: Self { self }

  case daily
  case weekly
  case biweekly
  case monthly
  case quarterly
  case semiannually
  case annually

  public var description: String {
      switch self {
      case .daily:
        return String(localized: "Daily", bundle: .module)
      case .weekly:
        return String(localized: "Weekly", bundle: .module)
      case .biweekly:
        return String(localized: "Biweekly", bundle: .module)
      case .monthly:
        return String(localized: "Monthly", bundle: .module)
      case .quarterly:
        return String(localized: "Quarterly", bundle: .module)
      case .semiannually:
        return String(localized: "Semiannually", bundle: .module)
      case .annually:
        return String(localized: "Annually", bundle: .module)
      }
  }
}
