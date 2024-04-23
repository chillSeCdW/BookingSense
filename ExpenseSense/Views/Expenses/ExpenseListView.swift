//
//  ExpenseListView.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 27.03.24.
//

import SwiftUI
import SwiftData

struct ExpenseListView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.editMode) private var editMode
  @Environment(\.modelContext) private var modelContext
  @Query private var entries: [ExpenseEntry]

  @State private var toast: Toast?

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
      Text("Select an item")
    }.toastView(toast: $toast)
  }

  private func addEntry() {
      withAnimation {
        let newItem = ExpenseEntry(
          name: "testName",
          amount: Decimal(10.1),
          amountPrefix: .plus,
          interval: .weekly
        )
        modelContext.insert(newItem)
      }
  }

  private func deleteAllItems() {
      withAnimation {
        entries.forEach { entry in
          modelContext.delete(entry)
        }
      }
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
  ExpenseListView()
        .modelContainer(previewContainer)
}
