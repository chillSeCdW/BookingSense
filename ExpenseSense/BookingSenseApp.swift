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
    if CommandLine.arguments.contains("enable-testing-empty") {
      let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
      return factory.container
    }
    if CommandLine.arguments.contains("enable-testing-data") {
      let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
      factory.addExamples(ContainerFactory.generateFixedEntriesItems())
      return factory.container
    }
    #endif

    let factory = ContainerFactory(BookingEntry.self, storeInMemory: false)
    return factory.container
  }()

  init() {
    setupVersion()
  }

  var body: some Scene {
      WindowGroup {
          ContentView()
      }
      .modelContainer(sharedModelContainer)
  }

  func setupVersion() {
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    UserDefaults.standard.set("Version \(version ?? "") (\(build ?? ""))", forKey: "app_version")
  }
}
