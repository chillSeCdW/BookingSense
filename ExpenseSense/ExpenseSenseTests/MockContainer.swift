//
//  MockContainer.swift
//  ExpenseSenseTests
//
//  Created by Kenny Salazar on 28.04.24.
//

import Foundation
import SwiftData
@testable import ExpenseSense

@MainActor
var mockContainer: ModelContainer {
  do {
    let container = try ModelContainer(
      for: ExpenseEntry.self,
      configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    return container
  } catch {
    fatalError("Failed to create mock container")
  }
}
