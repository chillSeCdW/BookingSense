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
import BookingSenseData

@main
struct BookingSenseApp: App {

  @AppStorage("resetTips") var resetTips = false
  @AppStorage("numberOfVisits") var numberOfVisits = 0

  let modelContainer = DataModel.shared.modelContainer

  @State private var appStates = AppStates()

  init() {
    setupVersion()
    if resetTips {
      resetTips = false
      try? Tips.resetDatastore()
    }
    //    Tips.showAllTipsForTesting()

    #if DEBUG
    if CommandLine.arguments.contains("disableTips") {
      numberOfVisits = 0
      return
    }
    if CommandLine.arguments.contains("insert-testing-data") {
      ContainerFactory.addExamples(
        ContainerFactory.generateFixedEntriesItems(),
        modelContext: modelContainer.mainContext
      )
    }
    #endif

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
    .modelContainer(modelContainer)
  }

  func setupVersion() {
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    UserDefaults.standard.set("Version \(version ?? "") (\(build ?? ""))", forKey: "app_version")
  }
}
