//
//  ExpenseSenseApp.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 18.03.24.
//

import SwiftUI
import SwiftData

typealias ExpenseEntry = ExpenseSchemaV1.ExpenseEntry

@main
struct ExpenseSenseApp: App {
  var sharedModelContainer: ModelContainer = {
    #if DEBUG
    if CommandLine.arguments.contains("enable-testing") {
      let factory = ContainerFactory(ExpenseEntry.self, storeInMemory: true)
      factory.addExamples(ContainerFactory.generateFixedEntriesItems())
      return factory.container
    }
    #endif

    let factory = ContainerFactory(ExpenseEntry.self, storeInMemory: false)
    return factory.container
  }()

  var body: some Scene {
      WindowGroup {
          ContentView()
      }
      .modelContainer(sharedModelContainer)
  }
}
