//
//  ExpenseSenseApp.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 18.03.24.
//

import SwiftUI
import SwiftData

@main
struct ExpenseSenseApp: App {
  var sharedModelContainer: ModelContainer = {
      let schema = Schema([
          ExpenseEntry.self
      ])
      let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

      do {
          return try ModelContainer(for: schema, configurations: [modelConfiguration])
      } catch {
          fatalError("Could not create ModelContainer: \(error)")
      }
  }()

  var body: some Scene {
      WindowGroup {
          ContentView()
      }
      .modelContainer(sharedModelContainer)
  }
}
