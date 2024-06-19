// Created for BookingSense on 14.05.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData

struct AdditionalInfoView: View {
  @Query private var entries: [BookingEntry]

  var body: some View {
    let monthlyDailyCosts = calculateMonthlyCostsOf(.daily)
    let monthlyWeeklyCosts = calculateMonthlyCostsOf(.weekly)
    let monthlyBiWeeklyCosts = calculateMonthlyCostsOf(.biweekly)
    let monthlyQuarterlyCosts = calculateMonthlyCostsOf(.quarterly)
    let monthlySemiAnnuallyCosts = calculateMonthlyCostsOf(.semiannually)
    let monthlyAnnuallyCosts = calculateMonthlyCostsOf(.annually)

    if monthlyDailyCosts > 0 {
      InfoView(
        text: LocalizedStringKey("Monthly costs of daily"),
        number: monthlyDailyCosts,
        format: .currency(code: Locale.current.currency!.identifier)
      )
    }
    if monthlyWeeklyCosts > 0 {
      InfoView(
        text: LocalizedStringKey("Monthly costs of weekly"),
        number: monthlyWeeklyCosts,
        format: .currency(code: Locale.current.currency!.identifier)
      )
    }
    if monthlyBiWeeklyCosts > 0 {
      InfoView(
        text: LocalizedStringKey("Monthly costs of biweekly"),
        number: monthlyBiWeeklyCosts,
        format: .currency(code: Locale.current.currency!.identifier)
      )
    }

    if monthlyQuarterlyCosts > 0 {
      InfoView(
        text: LocalizedStringKey("Monthly costs of quarterly"),
        number: monthlyQuarterlyCosts,
        format: .currency(code: Locale.current.currency!.identifier)
      )
    }
    if monthlySemiAnnuallyCosts > 0 {
      InfoView(
        text: LocalizedStringKey("Monthly costs of semiannually"),
        number: monthlySemiAnnuallyCosts,
        format: .currency(code: Locale.current.currency!.identifier)
      )
    }
    if monthlyAnnuallyCosts > 0 {
      InfoView(
        text: LocalizedStringKey("Monthly costs of annually"),
        number: calculateMonthlyCostsOf(.annually),
        format: .currency(code: Locale.current.currency!.identifier)
      )
    }

    InfoView(
      text: LocalizedStringKey("To cover non-monthly deductions"),
      number: calculateSaveMonthly(),
      format: .currency(code: Locale.current.currency!.identifier)
    )
  }

  private func calculateMonthlyCostsOf(_ interval: Interval) -> Decimal {
    var totalMonthlyCosts: Decimal = Decimal()

    for entry in entries where entry.amountPrefix == .minus && entry.interval == interval.rawValue {
      let curInterval = Interval(rawValue: entry.interval)
      totalMonthlyCosts += entry.amount * Constants.getTimesValue(from: curInterval, to: .monthly)

    }

    return totalMonthlyCosts
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
  return AdditionalInfoView()
    .modelContainer(factory.container)
}
