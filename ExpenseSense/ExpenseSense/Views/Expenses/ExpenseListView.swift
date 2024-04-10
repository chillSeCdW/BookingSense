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
            ExpenseEntryView(expenseEntry: entry)
          } label: {
            Text("\(entry.name)  \(entry.amount) - \(entry.interval)")
          }.listRowBackground(Color(UIColor.random()))
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
        let newItem = ExpenseEntry(
          name: "testName",
          amount: 10.0,
          amountPrefix: .plus,
          interval: .weekly
        )
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

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
          red: .random(in: 0...1),
          green: .random(in: 0...1),
          blue: .random(in: 0...1),
          alpha: 1.0
        )
    }
}
