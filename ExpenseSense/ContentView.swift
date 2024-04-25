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
      ExpenseNavigationSplitView(createToast: createToast)
        .tabItem {
            Label("Expenses", systemImage: "list.dash")
        }
    }
    .environment(viewInfo)
    .environment(navigationContext)
    .toastView(toast: $toast)
  }

  private func createToast(toastType: ToastStyle, message: String) {
    switch toastType {
    case .info:
      toast = Toast(style: .info, title: String(localized: "Info"), message: message, duration: 10, width: 160)
    default:
      toast = Toast(style: .error, title: String(localized: "Error"), message: message, duration: 10, width: 160)
    }
  }
}

#Preview {
    ContentView()
        .modelContainer(for: ExpenseEntry.self, inMemory: true)
}
