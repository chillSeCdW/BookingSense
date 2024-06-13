// Created for BookingSense on 12.06.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData
import TipKit

struct MonthlyInsightsView: View {
  @Query private var entries: [BookingEntry]
  @State var showInfoMonthlyCosts: Bool = false

  var body: some View {
    InfoView(
      text: "Total monthly costs",
      number: calculateMonthlyCostsOf(.monthly),
      format: .currency(code: Locale.current.currency!.identifier),
      infoHeadline: "How it's calculated",
      infoText: "calculated total monthly costs"
    )
  }

  private func calculateMonthlyCostsOf(_ interval: Interval) -> Decimal {
    var totalMonthlyCosts: Decimal = Decimal()

    for entry in entries where entry.amountPrefix == .minus {
      if Interval(rawValue: entry.interval) == interval {
        totalMonthlyCosts += entry.amount
      }
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
  return MonthlyInsightsView()
    .modelContainer(factory.container)

}
