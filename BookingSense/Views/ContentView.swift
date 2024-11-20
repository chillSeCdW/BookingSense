//
//  ContentView.swift
//  BookingSense
//
//  Created by kenny on 18.03.24.
//

import SwiftUI
import SwiftData
import StoreKit

struct ContentView: View {
  @Environment(AppStates.self) var appStates
  @Environment(\.purchaseStatus) private var purchaseStatus
  @Environment(\.purchaseStatusIsLoading) private var purchaseStatusIsLoading
  @Environment(\.requestReview) private var requestReview
  @Environment(\.scenePhase) var scenePhase
  @AppStorage("numberOfVisits") var numberOfVisits = 0
  @AppStorage("tmpBlurSensitive") var tmpBlurSensitive = false

  private var hasFullAccess: Bool {
      return purchaseStatus != .defaultAccess && !purchaseStatusIsLoading
  }

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

#Preview {
  let factory = ContainerFactory(BookingSchemaV4.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateFixedEntriesItems())
  return ContentView()
    .environment(AppStates())
    .modelContainer(factory.container)
}
