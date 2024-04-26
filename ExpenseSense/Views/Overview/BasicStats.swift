//
//  BasicStats.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 26.04.24.
//

import SwiftUI
import SwiftData

struct BasicStats: View {
  @Query private var entries: [ExpenseEntry]

  var body: some View {
    VStack {
      HStack {
        Text("Your Total plus:")
        Text(calculateTotals(.plus), format: .currency(code: Locale.current.currency!.identifier))
      }
    }
    VStack {
      HStack {
        Text("Your Total minus:")
        Text(calculateTotals(.minus), format: .currency(code: Locale.current.currency!.identifier))
      }
    }
  }

  func calculateTotals(_ amountPrefix: AmountPrefix) -> Decimal {
    var calcu: Decimal = Decimal()

    for entry in entries where entry.amountPrefix == amountPrefix {
      calcu += entry.amount * getTimesValue(interval: Interval(rawValue: entry.interval))
    }

    return calcu
  }

  private func getTimesValue(interval: Interval?) -> Decimal {
    switch interval {
    case .daily:
      return 365
    case .weekly:
      return 52
    case .biweekly:
      return 26
    case .monthly:
      return 12
    case .quarterly:
      return 4
    case .semiannually:
      return 2
    case .annually:
      return 1
    case .none:
      return 0
    }
  }
}

#Preview {
  BasicStats()
    .modelContainer(previewContainer)
}