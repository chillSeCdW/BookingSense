//
//  BookingSenseApp.swift
//  BookingSense
//
//  Created by kenny on 18.03.24.
//

import SwiftUI
import SwiftData
import TipKit
import MijickPopupView

typealias BookingEntry = BookingSchemaV2.BookingEntry

@main
struct BookingSenseApp: App {

  @AppStorage("resetTips") var resetTips = false
  @AppStorage("numberOfVisits") var numberOfVisits = 0

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

    let factory = ContainerFactory(BookingEntry.self, storeInMemory: false, migrationPlan: ExpenseMigrationV1ToV2.self)
    return factory.container
  }()

  @State private var appStates = AppStates()

  init() {
    setupVersion()
    if resetTips {
      resetTips = false
      try? Tips.resetDatastore()
    }
    //    Tips.showAllTipsForTesting()

    if CommandLine.arguments.contains("disableTips") {
      numberOfVisits = 0
      return
    }

    try? Tips.configure([
      .displayFrequency(.immediate)
    ])
    _ = Tips.MaxDisplayCount(2)
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
        .implementPopupView()
        .environment(appStates)
    }
    .modelContainer(sharedModelContainer)
  }

  func setupVersion() {
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    UserDefaults.standard.set("Version \(version ?? "") (\(build ?? ""))", forKey: "app_version")
  }
}
