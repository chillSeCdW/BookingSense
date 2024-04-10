//
//  AmountPrefix.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 10.04.24.
//

import Foundation

enum AmountPrefix: Codable, CaseIterable, Identifiable {
  var id: Self { self }

  case plus
  case minus

  var description: String {
      switch self {
      case .plus:
        return "-"
      case .minus:
        return "+"
      }
  }
}
