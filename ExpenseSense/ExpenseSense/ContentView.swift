//
//  ContentView.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 18.03.24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
      TabView {
        OverviewView()
          .tabItem {
            Label("Overview", systemImage: "dollarsign.arrow.circlepath")
          }
        ExpenseListView()
          .tabItem {
              Label("Expenses", systemImage: "list.dash")
          }
      }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
