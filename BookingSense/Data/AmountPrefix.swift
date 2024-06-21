//
//  AmountPrefix.swift
//  BookingSense
//
//  Created by kenny on 10.04.24.
//

import Foundation

enum AmountPrefix: Codable, CaseIterable, Identifiable {
  var id: Self { self }

  case plus
  case minus
  case saving

  var description: String {
      switch self {
      case .plus:
        return "➕"
      case .minus:
        return "➖"
      case .saving:
        return "💰"
      }
  }
}