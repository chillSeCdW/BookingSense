//
//  ExpenseListView.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 27.03.24.
//

import SwiftUI
import SwiftData

struct ExpenseNavigationSplitView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.editMode) private var editMode
  @Environment(\.modelContext) private var modelContext
  @Query private var entries: [ExpenseEntry]
  @State private var showingSheet = false

  var createToast: ((ToastStyle, String) -> Void)

  var body: some View {
    NavigationSplitView {
      List {
        PredicatedListEntriesView(interval: .annually, createToast: createToast)
        PredicatedListEntriesView(interval: .semiannually, createToast: createToast)
        PredicatedListEntriesView(interval: .quarterly, createToast: createToast)
        PredicatedListEntriesView(interval: .monthly, createToast: createToast)
        PredicatedListEntriesView(interval: .biweekly, createToast: createToast)
        PredicatedListEntriesView(interval: .weekly, createToast: createToast)
        PredicatedListEntriesView(interval: .daily, createToast: createToast)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton()
        }
        ToolbarItem {
          DeleteAllButtonView {
            deleteAllItems()
          }
        }
        ToolbarItem {
            Button(action: addEntry) {
                Label("Add Item", systemImage: "plus")
            }
        }
      }
    } detail: {
      Text("Select an entry")
    }.sheet(isPresented: $showingSheet, content: {
      ExpenseEntryView(showToast: createToast)
    })
  }

  private func addEntry() {
    withAnimation {
      showingSheet.toggle()
    }
  }

  private func deleteAllItems() {
    withAnimation {
      entries.forEach { entry in
        modelContext.delete(entry)
      }
    }
  }
}

#Preview {
  ExpenseNavigationSplitView { toastType, message in
    print(toastType)
    print(message)
  }.modelContainer(previewContainer)
}
