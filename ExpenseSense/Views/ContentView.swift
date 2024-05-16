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
