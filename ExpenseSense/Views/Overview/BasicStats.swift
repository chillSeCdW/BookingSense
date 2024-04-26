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
      calcu += entry.amount
    }

    return calcu
  }
}

#Preview {
  BasicStats()
    .modelContainer(previewContainer)
}
