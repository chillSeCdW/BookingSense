//
//  PreviewContainer.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 23.04.24.
//

import SwiftUI
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: ExpenseEntry.self,
                                           configurations: .init(isStoredInMemoryOnly: true))
        for _ in 1...25 {
            container.mainContext.insert(generateRandomEntriesItem())
        }

        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

func generateRandomEntriesItem() -> ExpenseEntry {
    let names = [ "Rent", "Car", "Groceries", "Gym", "Internet", "Netflix", "Donations", "Phone", "Cloud" ]

    let randomIndex = Int.random(in: 0..<names.count)
    let randomTask = names[randomIndex]

  return ExpenseEntry(name: randomTask,
                      amount: Decimal(Double.random(in: 0...500)),
                      amountPrefix: AmountPrefix.allCases.randomElement()!,
                      interval: Interval.allCases.randomElement()!
  )
}
