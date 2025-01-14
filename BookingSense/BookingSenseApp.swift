//
//  BookingSenseApp.swift
//  BookingSense
//
//  Created by kenny on 18.03.24.
//

import SwiftUI
import SwiftData
import TipKit
import MijickPopups

typealias BookingEntry = BookingSchemaV5.BookingEntry
typealias Tag = BookingSchemaV5.Tag
typealias TimelineEntry = BookingSchemaV5.TimelineEntry

@main
struct BookingSenseApp: App {

  @AppStorage("resetTips") var resetTips = false
  @AppStorage("numberOfVisits") var numberOfVisits = 0

  var sharedModelContainer: ModelContainer = {
#if DEBUG
    if CommandLine.arguments.contains("enable-testing-empty") {
      let factory = ContainerFactory(BookingSchemaV5.self, storeInMemory: true)
      return factory.container
    }
    if CommandLine.arguments.contains("enable-testing-data") {
      let factory = ContainerFactory(BookingSchemaV5.self, storeInMemory: true)
      factory.addExamples(ContainerFactory.generateFixedEntriesItems())
      return factory.container
    }
#endif
    return ContainerFactory(
      BookingSchemaV5.self,
      storeInMemory: false,
      migrationPlan: BookingMigrationV1ToV5.self
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
        .registerPopups(id: .shared) { $0
          .center {
            $0.cornerRadius(20)
              .tapOutsideToDismissPopup(true)
              .popupHorizontalPadding(20)
          }
        }
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
