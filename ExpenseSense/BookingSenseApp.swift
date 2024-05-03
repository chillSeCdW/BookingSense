//
//  BookingSenseApp.swift
//  BookingSense
//
//  Created by kenny on 18.03.24.
//

import SwiftUI
import SwiftData

typealias BookingEntry = BookingSchemaV1.BookingEntry

@main
struct BookingSenseApp: App {
  var sharedModelContainer: ModelContainer = {
    #if DEBUG
    if CommandLine.arguments.contains("enable-testing") {
      let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
      factory.addExamples(ContainerFactory.generateFixedEntriesItems())
      return factory.container
    }
    #endif

    let factory = ContainerFactory(BookingEntry.self, storeInMemory: false)
    return factory.container
  }()

  var body: some Scene {
      WindowGroup {
          ContentView()
      }
      .modelContainer(sharedModelContainer)
  }
}
