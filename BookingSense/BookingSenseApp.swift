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

typealias BookingEntry = BookingSchemaV1.BookingEntry

@main
struct BookingSenseApp: App {

  @AppStorage("resetTips") var resetTips = false

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
    if CommandLine.arguments.contains("enable-testing-data-max") {
      let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
      factory.addExamples(ContainerFactory.generateALotOfEntries())
      return factory.container
    }
//    Tips.showAllTipsForTesting()
//    Tips.showTipsForTesting([PrefixBookingTip.self])
    #endif

    let factory = ContainerFactory(BookingEntry.self, storeInMemory: false)
    return factory.container
  }()

  @State private var navigationContext = NavigationContext()
  @State private var viewInfo = SortingInfo()

  init() {
    setupVersion()
    if resetTips {
      resetTips = false
      try? Tips.resetDatastore()
    }

    try? Tips.configure([
      .displayFrequency(.immediate)
    ])
    _ = Tips.MaxDisplayCount(3)
  }

  var body: some Scene {
      WindowGroup {
          ContentView()
          .implementPopupView()
          .environment(viewInfo)
          .environment(navigationContext)
      }
      .modelContainer(sharedModelContainer)
  }

  func setupVersion() {
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    UserDefaults.standard.set("Version \(version ?? "") (\(build ?? ""))", forKey: "app_version")
  }
}
