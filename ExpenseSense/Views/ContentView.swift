//
//  ContentView.swift
//  BookingSense
//
//  Created by kenny on 18.03.24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @State private var navigationContext = NavigationContext()
  @State private var viewInfo = ViewInfo()

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
    .environment(viewInfo)
    .environment(navigationContext)
    .toastView(toast: $navigationContext.toast)
  }
}

#Preview {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return ContentView().modelContainer(factory.container)
}
