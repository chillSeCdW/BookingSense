//
//  ContentView.swift
//  BookingSense
//
//  Created by kenny on 18.03.24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @StateObject private var securityController = SecurityController()

  @Environment(\.modelContext) private var modelContext
  @Environment(NavigationContext.self) var navigationContext
  @Environment(ViewInfo.self) var viewInfo
  @Environment(\.scenePhase) var scenePhase

  var body: some View {
    @Bindable var navigationContext = navigationContext

    content
      .onAppear {
        securityController.showLockedViewIfEnabled()
      }
      .onChange(of: scenePhase) { _, newState in
        switch newState {
        case .background, .inactive:
          securityController.lockApp()
        default:
          break
        }
      }.toastView(toast: $navigationContext.toast)
  }

  var content: some View {
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
    .onChange(of: securityController.isAppLockEnabled) { _, newState  in
      securityController.appLockStateChange(newState)
    }
    .sheet(isPresented: $securityController.isLocked) {
      LockedView()
        .environmentObject(securityController)
        .interactiveDismissDisabled()
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
