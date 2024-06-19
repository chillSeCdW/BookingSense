// Created for BookingSense on 12.06.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData
import TipKit

struct IntervalInsightsView: View {
  @Query private var entries: [BookingEntry]
  @AppStorage("insightsInterval") private var interval: Interval = .monthly

  var body: some View {
    Picker("Interval", selection: $interval) {
      ForEach(Interval.allCases) { option in
        Text(String(describing: option.description))
      }
    }.accessibilityIdentifier("intervalPicker")
    .pickerStyle(.menu)
    InfoView(
      text: LocalizedStringKey("All costs as \(interval.description)"),
      number: calculateIntervalTotalDeductions(interval),
      format: .currency(code: Locale.current.currency!.identifier),
      infoHeadline: "How it's calculated",
      infoText: "calculated total monthly costs"
    )
    InfoView(
      text: LocalizedStringKey("Total \(interval.description) costs"),
      number: calculateIntervalTotalDeductions(interval),
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
  }

  private func calculateIntervalTotalDeductions(_ interval: Interval) -> Decimal {
    var totalcosts: Decimal = Decimal()

    for entry in entries where entry.amountPrefix == .minus && entry.interval == interval.rawValue {
      totalcosts += entry.amount
    }

    for entry in entries where entry.amountPrefix == .saving && entry.interval == interval.rawValue {
      totalcosts += entry.amount
    }

    return calculateIntervalDeductionsOf(interval) + calculateIntervalSavings(interval)
  }

  private func calculateIntervalDeductionsOf(_ interval: Interval) -> Decimal {
    var totalMonthlyCosts: Decimal = Decimal()

    for entry in entries where entry.amountPrefix == .minus && entry.interval == interval.rawValue {
      totalMonthlyCosts += entry.amount
    }

    return totalMonthlyCosts
  }

  private func calculateIntervalSavings(_ interval: Interval) -> Decimal {
    var totalMonthlyCosts: Decimal = Decimal()

    for entry in entries where entry.amountPrefix == .saving && entry.interval == interval.rawValue {
      totalMonthlyCosts += entry.amount
    }

    return totalMonthlyCosts
  }
}

#Preview {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return IntervalInsightsView()
    .modelContainer(factory.container)

}
