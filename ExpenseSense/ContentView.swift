//
//  ContentView.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 18.03.24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @State private var toast: Toast?
  @State private var navigationContext = NavigationContext()
  @State private var viewInfo = ViewInfo()

  var body: some View {
    TabView {
      OverviewView()
        .tabItem {
          Label("Overview", systemImage: "dollarsign.arrow.circlepath")
      }
      ExpenseNavigationSplitView(addToast: addToast)
        .tabItem {
            Label("Expenses", systemImage: "list.dash")
        }
    }
    .environment(viewInfo)
    .environment(navigationContext)
    .toastView(toast: $toast)
  }

  private func addToast(createdToast: Toast) {
    toast = createdToast
  }
}

#Preview {
  let factory = ContainerFactory(ExpenseEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return ContentView().modelContainer(factory.container)
}
