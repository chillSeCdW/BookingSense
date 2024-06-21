// Created for BookingSense on 12.06.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData
import TipKit

struct IntervalInsightsView: View {
  @Query private var entries: [BookingEntry]
  @AppStorage("insightsInterval") private var interval: Interval = .monthly

  var body: some View {
    InfoView(
      text: LocalizedStringKey("All income as \(interval.description)"),
      number: calculateIntervalTotalsFor(.plus, interval: interval),
      format: .currency(code: Locale.current.currency!.identifier),
      infoHeadline: LocalizedStringKey("How it's calculated"),
      infoText: LocalizedStringKey("calculated total \(interval.description) income"),
      showApprox: true
    )
    InfoView(
      text: LocalizedStringKey("All costs as \(interval.description)"),
      number: calculateIntervalTotalsFor(.minus, interval: interval),
      format: .currency(code: Locale.current.currency!.identifier),
      infoHeadline: LocalizedStringKey("How it's calculated"),
      infoText: LocalizedStringKey("calculated total \(interval.description) costs"),
      showApprox: true
    )
    InfoView(
      text: LocalizedStringKey("All savings as \(interval.description)"),
      number: calculateIntervalTotalsFor(.saving, interval: interval),
      format: .currency(code: Locale.current.currency!.identifier),
      infoHeadline: LocalizedStringKey("How it's calculated"),
      infoText: LocalizedStringKey("calculated total \(interval.description) savings"),
      showApprox: true
    )
    InfoView(
      text: LocalizedStringKey("\(interval.description.capitalized) income"),
      number: calculateIntervalIncomeOf(interval),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: LocalizedStringKey("\(interval.description.capitalized) deductions"),
      number: calculateIntervalDeductionsOf(interval),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: LocalizedStringKey("\(interval.description.capitalized) savings"),
      number: calculateIntervalSavings(interval),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: LocalizedStringKey("\(interval.description.capitalized) left"),
      number: calculateIntervalLeft(interval),
      format: .currency(code: Locale.current.currency!.identifier)
    )
  }

  private func calculateIntervalTotalsFor(_ amountPrefix: AmountPrefix, interval: Interval) -> Decimal {
    var total: Decimal = Decimal()

    for entry in entries where entry.amountPrefix == amountPrefix {
      total += entry.amount * Constants.getTimesValue(from: Interval(rawValue: entry.interval), to: interval)
    }

    return total
  }

  private func calculateAllIntervalTotalDeductionsFor(_ interval: Interval) -> Decimal {
    var totalcosts: Decimal = Decimal()

    for curInterval in Interval.allCases {
      totalcosts += calculateIntervalTotalDeductions(curInterval) *
      Constants.getTimesValue(from: curInterval, to: interval)
    }

    return totalcosts
  }

  private func calculateIntervalTotalDeductions(_ interval: Interval) -> Decimal {
    return calculateIntervalDeductionsOf(interval) + calculateIntervalSavings(interval)
  }

  private func calculateIntervalLeft(_ interval: Interval) -> Decimal {
    return calculateIntervalTotalsFor(.plus, interval: interval) -
    (calculateIntervalDeductionsOf(interval) + calculateIntervalSavings(interval))
  }

  private func calculateIntervalIncomeOf(_ interval: Interval) -> Decimal {
    var totalIntervalCosts: Decimal = Decimal()

    for entry in entries where entry.amountPrefix == .plus && entry.interval == interval.rawValue {
      totalIntervalCosts += entry.amount
    }

    return totalIntervalCosts
  }

  private func calculateIntervalDeductionsOf(_ interval: Interval) -> Decimal {
    var totalIntervalCosts: Decimal = Decimal()

    for entry in entries where entry.amountPrefix == .minus && entry.interval == interval.rawValue {
      totalIntervalCosts += entry.amount
    }

    return totalIntervalCosts
  }

  private func calculateIntervalSavings(_ interval: Interval) -> Decimal {
    var totalIntervalSavings: Decimal = Decimal()

    for entry in entries where entry.amountPrefix == .saving && entry.interval == interval.rawValue {
      totalIntervalSavings += entry.amount
    }

    return totalIntervalSavings
  }
}

#Preview {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return IntervalInsightsView()
    .modelContainer(factory.container)

}