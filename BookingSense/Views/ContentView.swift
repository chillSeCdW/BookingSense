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

struct ContentView: View {
  @Environment(AppStates.self) var appStates
  @Environment(\.requestReview) private var requestReview
  @Environment(\.scenePhase) var scenePhase
  @AppStorage("numberOfVisits") var numberOfVisits = 0
  @AppStorage("tmpBlurSensitive") var tmpBlurSensitive = false

  var body: some View {
    TabView {
      OverviewView()
        .tabItem {
          Label("Overview", systemImage: "dollarsign.arrow.circlepath")
        }
      if appStates.showTimelineTab {
        TimelineView()
          .tabItem {
            Label("Timeline", systemImage: "calendar.day.timeline.left")
          }
      }
      BookingNavigationStackView()
        .tabItem {
          Label("Bookings", systemImage: "list.dash")
        }
      SettingsNavigationStackView()
        .tabItem {
          Label("Settings", systemImage: "gear")
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
