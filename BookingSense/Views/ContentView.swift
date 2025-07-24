//
//  ContentView.swift
//  BookingSense
//
//  Created by kenny on 18.03.24.
//

import SwiftUI
import SwiftData
import StoreKit
import BookingSenseData
import WidgetKit

struct ContentView: View {
  @Environment(AppStates.self) var appStates
  @Environment(Navigator.self) var navigator
  @Environment(\.modelContext) private var modelContext
  @Environment(\.requestReview) private var requestReview
  @Environment(\.scenePhase) var scenePhase
  @AppStorage("numberOfVisits") var numberOfVisits = 0
  @AppStorage("tmpBlurSensitive") var tmpBlurSensitive = false

  var body: some View {
    @Bindable var navigator = navigator

    TabView(selection: $navigator.selectedTab) {
      Tab("Statistics", systemImage: "chart.xyaxis.line", value: .statistics) {
        StatisticsView()
      }
      if appStates.showTimelineTab {
        Tab("Timeline", systemImage: "calendar.day.timeline.left", value: .timeline) {
          TimelineView()
        }
      }
      Tab("Bookings", systemImage: "list.dash", value: .bookings) {
        BookingNavigationStackView()
      }
      Tab("Settings", systemImage: "gear", value: .settings) {
        SettingsNavigationStackView()
      }
    }
    .onChange(of: scenePhase) { _, newPhase in
      if !appStates.authenticationActive {
        if newPhase == .active {
          if tmpBlurSensitive == true {
            appStates.blurSensitive.toggle()
            tmpBlurSensitive.toggle()
          }
        } else if newPhase == .inactive {
          if appStates.blurSensitive == false {
            appStates.blurSensitive.toggle()
            tmpBlurSensitive.toggle()
          }
        }
      }
    }
    .onAppear {
      if numberOfVisits >= 5 {
        requestReview()
        numberOfVisits = 0
      } else {
        numberOfVisits += 1
      }
    }
  }
}

#if DEBUG
#Preview {
  let modelContainer = DataModel.shared.previewContainer
  return ContentView()
    .environment(AppStates())
    .modelContainer(modelContainer)
}
#endif
