//
//  ExpenseListView.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 27.03.24.
//

import SwiftUI
import SwiftData

struct ExpenseListView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var entries: [ExpenseEntry]
  
  var body: some View {
    NavigationSplitView {
      List {
        ForEach(entries) { entry in
          NavigationLink {
            Text("Item at \(entry.name), \(entry.amount)")
          } label: {
            Text("\(entry.name)  \(entry.amount.formatted(.currency(code: "USD")))")
          }
        }
        .onDelete(perform: deleteItems)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton()
        }
        ToolbarItem {
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
        }
      }
    } detail: {
      Text("Select an item")
    }
  }
  
  private func addItem() {
      withAnimation {
        let newItem = ExpenseEntry(name: "testName", amount: 10.0, interval: .weekly)
        modelContext.insert(newItem)
      }
  }

  private func deleteItems(offsets: IndexSet) {
      withAnimation {
          for index in offsets {
              modelContext.delete(entries[index])
          }
      }
  }
}

#Preview {
  ExpenseListView()
        .modelContainer(for: ExpenseEntry.self, inMemory: true)
}
