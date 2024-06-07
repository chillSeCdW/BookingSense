// Created for BookingSense on 14.05.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData

struct HelpfulInfoView: View {
  @Query private var entries: [BookingEntry]

  var body: some View {
    InfoView(
      text: "Monthly costs of daily",
      number: calculateMonthlyCostsOf(.daily),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: "Monthly costs of weekly",
      number: calculateMonthlyCostsOf(.weekly),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: "Monthly costs of biweekly",
      number: calculateMonthlyCostsOf(.biweekly),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: "Monthly costs of quarterly",
      number: calculateMonthlyCostsOf(.quarterly),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: "Monthly costs of semiannually",
      number: calculateMonthlyCostsOf(.semiannually),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: "Monthly costs of annually",
      number: calculateMonthlyCostsOf(.annually),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: "To cover non-monthly deductions",
      number: calculateSaveMonthly(),
      format: .currency(code: Locale.current.currency!.identifier)
    )
  }

  private func calculateMonthlyCostsOf(_ interval: Interval) -> Decimal {
    var totalMonthlyCosts: Decimal = Decimal()

    for entry in entries where entry.amountPrefix == .minus {
      if Interval(rawValue: entry.interval) == interval {
        totalMonthlyCosts += entry.amount * Constants.getTimesValue(interval: Interval(rawValue: entry.interval))
      }
    }

    return totalMonthlyCosts / 12
  }

  private func calculateSaveMonthly() -> Decimal {
    var totalNonMonthlyCosts: Decimal = Decimal()

    for interval in Interval.allCases where interval != .monthly {
      totalNonMonthlyCosts += calculateMonthlyCostsOf(interval)
    }

    return totalNonMonthlyCosts
  }
}

#Preview {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return HelpfulInfoView()
    .modelContainer(factory.container)
}
