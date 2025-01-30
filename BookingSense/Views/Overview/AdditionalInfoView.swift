// Created for BookingSense on 14.05.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData
import BookingSenseData

struct AdditionalInfoView: View {
  @Query private var entries: [BookingEntry]
  @AppStorage("insightsInterval") private var interval: Interval = .monthly

  var body: some View {
    let dailyCosts = calculateCosts(.daily, to: interval)
    let weeklyCosts = calculateCosts(.weekly, to: interval)
    let biWeeklyCosts = calculateCosts(.biweekly, to: interval)
    let monthlyCosts = calculateCosts(.monthly, to: interval)
    let quarterlyCosts = calculateCosts(.quarterly, to: interval)
    let semiAnnuallyCosts = calculateCosts(.semiannually, to: interval)
    let annuallyCosts = calculateCosts(.annually, to: interval)

    if dailyCosts > 0 && interval != .daily {
      InfoView(
        text: LocalizedStringKey("\(interval.description.capitalized) costs of daily"),
        number: dailyCosts,
        format: .currency(code: Locale.current.currency!.identifier)
      )
    }
    if weeklyCosts > 0 && interval != .weekly {
      InfoView(
        text: LocalizedStringKey("\(interval.description.capitalized) costs of weekly"),
        number: weeklyCosts,
        format: .currency(code: Locale.current.currency!.identifier)
      )
    }
    if biWeeklyCosts > 0 && interval != .biweekly {
      InfoView(
        text: LocalizedStringKey("\(interval.description.capitalized) costs of biweekly"),
        number: biWeeklyCosts,
        format: .currency(code: Locale.current.currency!.identifier)
      )
    }
    if monthlyCosts > 0 && interval != .monthly {
      InfoView(
        text: LocalizedStringKey("\(interval.description.capitalized) costs of monthly"),
        number: monthlyCosts,
        format: .currency(code: Locale.current.currency!.identifier)
      )
    }
    if quarterlyCosts > 0 && interval != .quarterly {
      InfoView(
        text: LocalizedStringKey("\(interval.description.capitalized) costs of quarterly"),
        number: quarterlyCosts,
        format: .currency(code: Locale.current.currency!.identifier)
      )
    }
    if semiAnnuallyCosts > 0 && interval != .semiannually {
      InfoView(
        text: LocalizedStringKey("\(interval.description.capitalized) costs of semiannually"),
        number: semiAnnuallyCosts,
        format: .currency(code: Locale.current.currency!.identifier)
      )
    }
    if annuallyCosts > 0 && interval != .annually {
      InfoView(
        text: LocalizedStringKey("\(interval.description.capitalized) costs of annually"),
        number: annuallyCosts,
        format: .currency(code: Locale.current.currency!.identifier)
      )
    }
    InfoView(
      text: LocalizedStringKey("To cover \(interval.description) deductions"),
      number: calculateSaveInterval(interval),
      format: .currency(code: Locale.current.currency!.identifier),
      infoHeadline: LocalizedStringKey("\(interval.description) cover details \(Constants.convertToNoun(interval))"),
      showApprox: true
    )
  }

  private func calculateCosts(_ from: Interval, to toInterval: Interval) -> Decimal {
    var totalIntervalCosts: Decimal = Decimal()

    for entry in entries where
    entry.bookingType == BookingType.minus.rawValue &&
    entry.interval == from.rawValue {
      let curInterval = Interval(rawValue: entry.interval)
      totalIntervalCosts += entry.amount * Constants.getTimesValue(from: curInterval, to: toInterval)
    }

    return totalIntervalCosts
  }

  private func calculateSaveInterval(_ calculateTo: Interval) -> Decimal {
    var totalDifferentIntervalCosts: Decimal = Decimal()

    for interval in Interval.allCases where interval != calculateTo {
      totalDifferentIntervalCosts += calculateCosts(interval, to: calculateTo)
    }

    return totalDifferentIntervalCosts
  }
}

#Preview {
  let factory = ContainerFactory(BookingSchemaV4.self, storeInMemory: true)
  ContainerFactory.addExamples(
    ContainerFactory.generateRandomEntriesItems(),
    modelContext: factory.container.mainContext
  )
  return AdditionalInfoView()
    .modelContainer(factory.container)
}
