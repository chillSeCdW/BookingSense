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
                                       tag: nil,
                                       amount: Decimal(Double.random(in: 0...500)),
                                       amountPrefix: AmountPrefix.allCases.randomElement()!,
                                       interval: Interval.allCases.randomElement()!)
      )
    }
    return returnResult
  }

  // swiftlint:disable function_body_length
  static func generateFixedEntriesItems() -> [BookingEntry] {
    var returnResult: [BookingEntry] = []

    returnResult.append(BookingEntry(name: "Trinkgeld",
                                     tag: nil,
                                     amount: 1,
                                     amountPrefix: AmountPrefix.plus,
                                     interval: .daily))
    returnResult.append(BookingEntry(name: "Cashback",
                                     tag: nil,
                                     amount: 10,
                                     amountPrefix: AmountPrefix.plus,
                                     interval: .weekly))
    returnResult.append(BookingEntry(name: "Tutoring",
                                     tag: nil,
                                     amount: 50,
                                     amountPrefix: AmountPrefix.plus,
                                     interval: .biweekly))
    returnResult.append(BookingEntry(name: "Salary",
                                     tag: nil,
                                     amount: 2500,
                                     amountPrefix: AmountPrefix.plus,
                                     interval: .monthly))
    returnResult.append(BookingEntry(name: "Rent Parking",
                                     tag: nil,
                                     amount: 150,
                                     amountPrefix: AmountPrefix.plus,
                                     interval: .monthly))
    returnResult.append(BookingEntry(name: "Investment",
                                     tag: nil,
                                     amount: 500,
                                     amountPrefix: AmountPrefix.plus,
                                     interval: .semiannually))
    returnResult.append(BookingEntry(name: "Festgeld",
                                     tag: nil,
                                     amount: 1000,
                                     amountPrefix: AmountPrefix.plus,
                                     interval: .annually))

    returnResult.append(BookingEntry(name: "Brötchen",
                                     tag: nil,
                                     amount: 2.5,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .daily))
    returnResult.append(BookingEntry(name: "Taschengeld Kinder",
                                     tag: nil,
                                     amount: 10,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .weekly))
    returnResult.append(BookingEntry(name: "Babysitter",
                                     tag: nil,
                                     amount: 50,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .biweekly))
    returnResult.append(BookingEntry(name: "Rent",
                                     tag: nil,
                                     amount: 800,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .monthly))
    returnResult.append(BookingEntry(name: "Netflix",
                                     tag: nil,
                                     amount: 20,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .monthly))
    returnResult.append(BookingEntry(name: "Benzin",
                                     tag: nil,
                                     amount: 150,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .monthly))
    returnResult.append(BookingEntry(name: "Youtube Premium",
                                     tag: nil,
                                     amount: 14,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .monthly))
    returnResult.append(BookingEntry(name: "iCloud",
                                     tag: nil,
                                     amount: 2,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .monthly))
    returnResult.append(BookingEntry(name: "GEZ",
                                     tag: nil,
                                     amount: 55,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .quarterly))
    returnResult.append(BookingEntry(name: "semiannuallyEntry",
                                     tag: nil,
                                     amount: 200,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .semiannually))
    returnResult.append(BookingEntry(name: "KFZ Steuer",
                                     tag: nil,
                                     amount: 450,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .annually))
    returnResult.append(BookingEntry(name: "TÜV",
                                     tag: nil,
                                     amount: 800,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .annually))

    returnResult.append(BookingEntry(name: "Einkauf Aufrundung",
                                     tag: nil,
                                     amount: 1,
                                     amountPrefix: AmountPrefix.saving,
                                     interval: .daily))
    returnResult.append(BookingEntry(name: "Bike saving",
                                     tag: nil,
                                     amount: 10,
                                     amountPrefix: AmountPrefix.saving,
                                     interval: .weekly))
    returnResult.append(BookingEntry(name: "Phone saving",
                                     tag: nil,
                                     amount: 20,
                                     amountPrefix: AmountPrefix.saving,
                                     interval: .biweekly))
    returnResult.append(BookingEntry(name: "Tagesgeld",
                                     tag: nil,
                                     amount: 500,
                                     amountPrefix: AmountPrefix.saving,
                                     interval: .monthly))
    returnResult.append(BookingEntry(name: "ETF",
                                     tag: nil,
                                     amount: 200,
                                     amountPrefix: AmountPrefix.saving,
                                     interval: .monthly))
    returnResult.append(BookingEntry(name: "Versicherung",
                                     tag: nil,
                                     amount: 200,
                                     amountPrefix: AmountPrefix.saving,
                                     interval: .quarterly))
    returnResult.append(BookingEntry(name: "Altervorsorge",
                                     tag: nil,
                                     amount: 200,
                                     amountPrefix: AmountPrefix.saving,
                                     interval: .semiannually))
    returnResult.append(BookingEntry(name: "Auto reperatur",
                                     tag: nil,
                                     amount: 500,
                                     amountPrefix: AmountPrefix.saving,
                                     interval: .annually))
    return returnResult
  }
  // swiftlint:enable function_body_length
}
