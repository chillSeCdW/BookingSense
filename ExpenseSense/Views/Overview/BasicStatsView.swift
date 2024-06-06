//
//  BasicStatsView.swift
//  BookingSense
//
//  Created by kenny on 26.04.24.
//

import SwiftUI
import SwiftData

struct BasicStatsView: View {
  @Query private var entries: [BookingEntry]

  var body: some View {
    InfoView(
      text: "Your total plus",
      number: calculateTotals(.plus),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: "Your total minus",
      number: calculateTotals(.minus),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: "Your total savings",
      number: calculateTotals(.saving),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: "Your total left",
      number: calculateLeft(),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: "Your total entries",
      number: Decimal(entries.count),
      format: .number
    )
  }

  private func calculateTotals(_ amountPrefix: AmountPrefix) -> Decimal {
    var calcu: Decimal = Decimal()

    for entry in entries where entry.amountPrefix == amountPrefix {
      calcu += entry.amount * Constants.getTimesValue(interval: Interval(rawValue: entry.interval))
    }

    return calcu
  }

  private func calculateLeft() -> Decimal {
    calculateTotals(.plus) - calculateTotals(.minus) - calculateTotals(.saving)
  }
}

#Preview {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return BasicStatsView()
    .modelContainer(factory.container)
}
