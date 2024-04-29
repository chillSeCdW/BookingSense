//
//  ContainerFactory.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 29.04.24.
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

  static func generateRandomEntriesItems() -> [ExpenseEntry] {
    var returnResult: [ExpenseEntry] = []
    let names = [ "Rent", "Car", "Groceries", "Gym", "Internet", "Netflix", "Donations", "Phone", "Cloud" ]

    let randomIndex = Int.random(in: 0..<names.count)
    let randomTask = names[randomIndex]

    for _ in 1...25 {
      returnResult.append(ExpenseEntry(name: randomTask,
                                       amount: Decimal(Double.random(in: 0...500)),
                                       amountPrefix: AmountPrefix.allCases.randomElement()!,
                                       interval: Interval.allCases.randomElement()!)
      )
    }
    return returnResult
  }

  static func generateFixedEntriesItems() -> [ExpenseEntry] {
    var returnResult: [ExpenseEntry] = []
    let names = [ "Salary", "Rent", "Car"]

    for (index, name) in names.enumerated() {
      returnResult.append(ExpenseEntry(name: name,
                                       amount: index == 0 ? Decimal(1000) : Decimal(100),
                                       amountPrefix: index == 0 ? AmountPrefix.plus : AmountPrefix.minus,
                                       interval: Interval.monthly)
      )
    }
    return returnResult
  }
}
