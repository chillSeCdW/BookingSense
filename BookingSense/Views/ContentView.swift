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
  @Environment(\.modelContext) private var modelContext
  @Environment(SortingInfo.self) var viewInfo
  @Environment(\.requestReview) private var requestReview
  @Environment(\.scenePhase) var scenePhase
  @AppStorage("numberOfVisits") var numberOfVisits = 0
  @AppStorage("blurSensitive") var blurSensitive = false
  @AppStorage("tmpBlurSensitive") var tmpBlurSensitive = false

  var body: some View {
    TabView {
      OverviewView()
        .tabItem {
          Label("Overview", systemImage: "dollarsign.arrow.circlepath")
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
      if newPhase == .active {
        if tmpBlurSensitive == true {
          blurSensitive.toggle()
          tmpBlurSensitive.toggle()
        }
      } else if newPhase == .inactive {
        if blurSensitive == false {
          blurSensitive.toggle()
          tmpBlurSensitive.toggle()
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
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateFixedEntriesItems())
  return ContentView()
    .environment(SortingInfo())
    .modelContainer(factory.container)
}
