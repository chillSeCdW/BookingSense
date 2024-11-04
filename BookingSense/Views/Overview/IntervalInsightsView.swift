// Created for BookingSense on 12.06.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData

struct IntervalInsightsView: View {
  @Query private var entries: [BookingEntry]
  @AppStorage("insightsInterval") private var interval: Interval = .monthly

  var body: some View {
    VStack(spacing: 13) {
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
        text: LocalizedStringKey("Total \(interval.description) left"),
        number: calculateIntervalLeft(interval),
        format: .currency(code: Locale.current.currency!.identifier),
        infoHeadline: LocalizedStringKey("How it's calculated"),
        infoText: LocalizedStringKey("calculated total left"),
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
    }.padding(.bottom, 5)
  }

  private func calculateIntervalTotalsFor(_ amountPrefix: AmountPrefix, interval: Interval) -> Decimal {
    return entries.filter { $0.amountPrefix == amountPrefix.rawValue }
      .map { entry in
        entry.amount * Constants.getTimesValue(from: Interval(rawValue: entry.interval), to: interval)
      }
      .reduce(0, +)
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
    (calculateIntervalTotalsFor(.minus, interval: interval) + calculateIntervalTotalsFor(.saving, interval: interval))
  }

  private func calculateIntervalIncomeOf(_ interval: Interval) -> Decimal {
    var totalIntervalCosts: Decimal = Decimal()

    for entry in entries where
    entry.amountPrefix == AmountPrefix.plus.rawValue &&
    entry.interval == interval.rawValue {
      totalIntervalCosts += entry.amount
    }

    return totalIntervalCosts
  }

  private func calculateIntervalDeductionsOf(_ interval: Interval) -> Decimal {
    var totalIntervalCosts: Decimal = Decimal()

    for entry in entries where
    entry.amountPrefix == AmountPrefix.minus.rawValue &&
    entry.interval == interval.rawValue {
      totalIntervalCosts += entry.amount
    }

    return totalIntervalCosts
  }

  private func calculateIntervalSavings(_ interval: Interval) -> Decimal {
    var totalIntervalSavings: Decimal = Decimal()

    for entry in entries where
    entry.amountPrefix == AmountPrefix.saving.rawValue &&
    entry.interval == interval.rawValue {
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
