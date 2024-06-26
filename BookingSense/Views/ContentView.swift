//
//  ContentView.swift
//  BookingSense
//
//  Created by kenny on 18.03.24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(NavigationContext.self) var navigationContext
  @Environment(ViewInfo.self) var viewInfo
  @Environment(\.scenePhase) var scenePhase
  @AppStorage("blurSensitive") var blurSensitive = false
  @AppStorage("tmpBlurSensitive") var tmpBlurSensitive = false

  var body: some View {
    @Bindable var navigationContext = navigationContext

    TabView {
      OverviewView()
        .tabItem {
          Label("Overview", systemImage: "dollarsign.arrow.circlepath")
        }
      BookingNavigationStackView()
        .tabItem {
          Label("Bookings", systemImage: "list.dash")
        }
    }
    .toastView(toast: $navigationContext.toast)
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
  }
}

#Preview {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateFixedEntriesItems())
  return ContentView()
    .environment(NavigationContext())
    .environment(ViewInfo())
    .modelContainer(factory.container)
}
