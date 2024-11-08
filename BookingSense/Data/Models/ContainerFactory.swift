//
//  ContainerFactory.swift
//  BookingSense
//
//  Created by kenny on 29.04.24.
//

import SwiftUI
import SwiftData

struct ContainerFactory {
  let container: ModelContainer

  init(_ models: any PersistentModel.Type..., storeInMemory: Bool, migrationPlan: SchemaMigrationPlan.Type? = nil) {
    let config = ModelConfiguration(isStoredInMemoryOnly: storeInMemory)
    let schema = Schema(models)
    do {
      container = try ModelContainer(for: schema, migrationPlan: migrationPlan, configurations: config)
    } catch {
      fatalError("Could not create preview container")
    }
  }

  func addExamples(_ examples: [any PersistentModel]) {
    Task { @MainActor in
      examples.forEach { example in
        container.mainContext.insert(example)
      }
    }
  }

  static func generateRandomEntriesItems() -> [BookingEntry] {
    var returnResult: [BookingEntry] = []
    let names = [ "Rent", "Car", "Groceries", "Gym", "Internet", "Netflix", "Donations", "Phone", "Cloud" ]

    for _ in 1...25 {
      let randomIndex = Int.random(in: 0..<names.count)
      let randomTask = names[randomIndex]

      returnResult.append(BookingEntry(name: randomTask,
                                       amount: Decimal(Double.random(in: 0...500)),
                                       amountPrefix: AmountPrefix.allCases.randomElement()!.rawValue,
                                       interval: Interval.allCases.randomElement()!,
                                       tag: nil,
                                       timelineEntries: nil)
      )
    }
    return returnResult
  }

  // swiftlint:disable function_body_length
  static func generateFixedEntriesItems() -> [BookingEntry] {
    var returnResult: [BookingEntry] = []
    let incomeTag: Tag = Tag(name: "income")
    let timelineEntry: TimelineEntry = TimelineEntry(
      state: TimelineEntryState.open.rawValue,
      name: "Brötchen",
      amount: 2.5,
      amountPrefix: AmountPrefix.minus.rawValue,
      isDue: Date.now,
      tag: nil,
      completedAt: nil,
      bookingEntry: nil
    )
    let timelineEntry1: TimelineEntry = TimelineEntry(
      state: TimelineEntryState.open.rawValue,
      name: "Brötchen",
      amount: 2.5,
      amountPrefix: AmountPrefix.minus.rawValue,
      isDue: Date.now.addingTimeInterval( 60 * 60 * 24 * 2),
      tag: nil,
      completedAt: nil,
      bookingEntry: nil
    )
    let timelineEntry2: TimelineEntry = TimelineEntry(
      state: TimelineEntryState.open.rawValue,
      name: "Brötchen",
      amount: 2.5,
      amountPrefix: AmountPrefix.minus.rawValue,
      isDue: Date.now.addingTimeInterval( 60 * 60 * 24),
      tag: nil,
      completedAt: nil,
      bookingEntry: nil
    )

    returnResult.append(BookingEntry(name: "Trinkgeld",
                                     amount: 1,
                                     amountPrefix: AmountPrefix.plus.rawValue,
                                     interval: .daily,
                                     tag: incomeTag,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Cashback",
                                     amount: 10,
                                     amountPrefix: AmountPrefix.plus.rawValue,
                                     interval: .weekly,
                                     tag: incomeTag,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Tutoring",
                                     amount: 50,
                                     amountPrefix: AmountPrefix.plus.rawValue,
                                     interval: .biweekly,
                                     tag: incomeTag,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Salary",
                                     amount: 2500,
                                     amountPrefix: AmountPrefix.plus.rawValue,
                                     interval: .monthly,
                                     tag: incomeTag,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Rent Parking",
                                     amount: 150,
                                     amountPrefix: AmountPrefix.plus.rawValue,
                                     interval: .monthly,
                                     tag: incomeTag,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Investment",
                                     amount: 500,
                                     amountPrefix: AmountPrefix.plus.rawValue,
                                     interval: .semiannually,
                                     tag: incomeTag,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Festgeld",
                                     amount: 1000,
                                     amountPrefix: AmountPrefix.plus.rawValue,
                                     interval: .annually,
                                     tag: incomeTag,
                                     timelineEntries: nil))

    returnResult.append(BookingEntry(name: "Brötchen",
                                     amount: 2.5,
                                     amountPrefix: AmountPrefix.minus.rawValue,
                                     interval: .daily,
                                     tag: nil,
                                     timelineEntries: [timelineEntry, timelineEntry1, timelineEntry2]))
    returnResult.append(BookingEntry(name: "Taschengeld Kinder",
                                     amount: 10,
                                     amountPrefix: AmountPrefix.minus.rawValue,
                                     interval: .weekly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Babysitter",
                                     amount: 50,
                                     amountPrefix: AmountPrefix.minus.rawValue,
                                     interval: .biweekly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Rent",
                                     amount: 800,
                                     amountPrefix: AmountPrefix.minus.rawValue,
                                     interval: .monthly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Netflix",
                                     amount: 20,
                                     amountPrefix: AmountPrefix.minus.rawValue,
                                     interval: .monthly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Benzin",
                                     amount: 150,
                                     amountPrefix: AmountPrefix.minus.rawValue,
                                     interval: .monthly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Youtube Premium",
                                     amount: 14,
                                     amountPrefix: AmountPrefix.minus.rawValue,
                                     interval: .monthly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "iCloud",
                                     amount: 2,
                                     amountPrefix: AmountPrefix.minus.rawValue,
                                     interval: .monthly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "GEZ",
                                     amount: 55,
                                     amountPrefix: AmountPrefix.minus.rawValue,
                                     interval: .quarterly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "semiannuallyEntry",
                                     amount: 200,
                                     amountPrefix: AmountPrefix.minus.rawValue,
                                     interval: .semiannually,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "KFZ Steuer",
                                     amount: 450,
                                     amountPrefix: AmountPrefix.minus.rawValue,
                                     interval: .annually,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "TÜV",
                                     amount: 800,
                                     amountPrefix: AmountPrefix.minus.rawValue,
                                     interval: .annually,
                                     tag: nil,
                                     timelineEntries: nil))

    returnResult.append(BookingEntry(name: "Einkauf Aufrundung",
                                     amount: 1,
                                     amountPrefix: AmountPrefix.saving.rawValue,
                                     interval: .daily,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Bike saving",
                                     amount: 10,
                                     amountPrefix: AmountPrefix.saving.rawValue,
                                     interval: .weekly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Phone saving",
                                     amount: 20,
                                     amountPrefix: AmountPrefix.saving.rawValue,
                                     interval: .biweekly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Tagesgeld",
                                     amount: 500,
                                     amountPrefix: AmountPrefix.saving.rawValue,
                                     interval: .monthly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "ETF",
                                     amount: 200,
                                     amountPrefix: AmountPrefix.saving.rawValue,
                                     interval: .monthly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Versicherung",
                                     amount: 200,
                                     amountPrefix: AmountPrefix.saving.rawValue,
                                     interval: .quarterly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Altervorsorge",
                                     amount: 200,
                                     amountPrefix: AmountPrefix.saving.rawValue,
                                     interval: .semiannually,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Auto reperatur",
                                     amount: 500,
                                     amountPrefix: AmountPrefix.saving.rawValue,
                                     interval: .annually,
                                     tag: nil,
                                     timelineEntries: nil))
    return returnResult
  }
  // swiftlint:enable function_body_length
}
