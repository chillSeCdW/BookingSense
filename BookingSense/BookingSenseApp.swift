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

typealias BookingEntry = BookingSchemaV4.BookingEntry
typealias Tag = BookingSchemaV4.Tag
typealias TimelineEntry = BookingSchemaV4.TimelineEntry

@main
struct BookingSenseApp: App {

  @AppStorage("resetTips") var resetTips = false
  @AppStorage("numberOfVisits") var numberOfVisits = 0

  var sharedModelContainer: ModelContainer = {
#if DEBUG
    if CommandLine.arguments.contains("enable-testing-empty") {
      let factory = ContainerFactory(BookingSchemaV4.self, storeInMemory: true)
      return factory.container
    }
    if CommandLine.arguments.contains("enable-testing-data") {
      let factory = ContainerFactory(BookingSchemaV4.self, storeInMemory: true)
      factory.addExamples(ContainerFactory.generateFixedEntriesItems())
      return factory.container
    }
#endif
    return ContainerFactory(
      BookingSchemaV4.self,
      storeInMemory: false,
      migrationPlan: BookingMigrationV1ToV4.self
    ).container
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
        .purchaseHandler()
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
