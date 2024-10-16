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
                                       tags: ["default"],
                                       amount: Decimal(Double.random(in: 0...500)),
                                       amountPrefix: AmountPrefix.allCases.randomElement()!,
                                       interval: Interval.allCases.randomElement()!)
      )
    }
    return returnResult
  }

  static func generateFixedEntriesItems() -> [BookingEntry] {
    var returnResult: [BookingEntry] = []

    returnResult.append(BookingEntry(name: "Salary",
                                     tags: ["default"],
                                     amount: 2500,
                                     amountPrefix: AmountPrefix.plus,
                                     interval: .monthly))
    returnResult.append(BookingEntry(name: "Rent Parking",
                                     tags: ["default"],
                                     amount: 150,
                                     amountPrefix: AmountPrefix.plus,
                                     interval: .monthly))

    returnResult.append(BookingEntry(name: "Brötchen",
                                     tags: ["default"],
                                     amount: 2.5,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .daily))
    returnResult.append(BookingEntry(name: "Taschengeld Kinder",
                                     tags: ["default"],
                                     amount: 10,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .weekly))
    returnResult.append(BookingEntry(name: "Reingungkraft",
                                     tags: ["default"],
                                     amount: 20,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .biweekly))
    returnResult.append(BookingEntry(name: "rent",
                                     tags: ["default"],
                                     amount: 800,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .monthly))
    returnResult.append(BookingEntry(name: "Netflix",
                                     tags: ["default"],
                                     amount: 20,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .monthly))
    returnResult.append(BookingEntry(name: "Benzin",
                                     tags: ["default"],
                                     amount: 150,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .monthly))
    returnResult.append(BookingEntry(name: "Youtube Premium",
                                     tags: ["default"],
                                     amount: 14,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .monthly))
    returnResult.append(BookingEntry(name: "iCloud",
                                     tags: ["default"],
                                     amount: 2,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .monthly))
    returnResult.append(BookingEntry(name: "GEZ",
                                     tags: ["default"],
                                     amount: 55,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .quarterly))
    returnResult.append(BookingEntry(name: "semiannuallyEntry",
                                     tags: ["default"],
                                     amount: 200,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .semiannually))
    returnResult.append(BookingEntry(name: "KFZ Steuer",
                                     tags: ["default"],
                                     amount: 150,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .annually))
    returnResult.append(BookingEntry(name: "TÜV",
                                     tags: ["default"],
                                     amount: 200,
                                     amountPrefix: AmountPrefix.minus,
                                     interval: .annually))

    returnResult.append(BookingEntry(name: "Tagesgeld",
                                     tags: ["default"],
                                     amount: 500,
                                     amountPrefix: AmountPrefix.saving,
                                     interval: .monthly))
    returnResult.append(BookingEntry(name: "ETF",
                                     tags: ["default"],
                                     amount: 200,
                                     amountPrefix: AmountPrefix.saving,
                                     interval: .monthly))
    return returnResult
  }
}
