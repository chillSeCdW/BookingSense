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
      text: LocalizedStringKey("Your total plus"),
      number: calculateYearlyTotals(.plus),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: LocalizedStringKey("Your total minus"),
      number: calculateYearlyTotals(.minus),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: LocalizedStringKey("Your total savings"),
      number: calculateYearlyTotals(.saving),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: LocalizedStringKey("Your total left"),
      number: calculateYearlyLeft(),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: LocalizedStringKey("Your total entries"),
      number: Decimal(entries.count),
      format: .number
    )
  }

  private func calculateYearlyTotals(_ amountPrefix: AmountPrefix) -> Decimal {
    var calcu: Decimal = Decimal()

    for entry in entries where entry.amountPrefix == amountPrefix {
      calcu += entry.amount * Constants.getTimesValue(from: Interval(rawValue: entry.interval), to: .annually)
    }

    return calcu
  }

  private func calculateYearlyLeft() -> Decimal {
    calculateYearlyTotals(.plus) - calculateYearlyTotals(.minus) - calculateYearlyTotals(.saving)
  }
}

#Preview {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return BasicStatsView()
    .modelContainer(factory.container)
}
