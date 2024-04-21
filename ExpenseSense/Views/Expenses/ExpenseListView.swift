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
  @Environment(Constants.self) private var constants
  @Query private var entries: [ExpenseEntry]

  @State private var toast: Toast?

  var body: some View {
    NavigationSplitView {
      List {
//        Section(header: Text("weekly")) {
//        }
        ForEach(entries) { entry in
          NavigationLink {
            ExpenseEntryView(expenseEntry: entry) { toastType, message in
              createToast(toastType: toastType, message: message)
            }
          } label: {
            Text("\(entry.name) \(entry.amountPrefix.description)\(entry.amount.formatted()) - \(entry.interval)")
          }
          .listRowBackground(
            HStack(spacing: 0) {
              Rectangle()
                .fill(Constants.init().listBackgroundColors[entry.amountPrefix]!)
                .frame(width: 10, height: UIScreen.main.bounds.height)
              Rectangle()
                .fill(colorScheme == .light ? .white : Color(uiColor: .darkGray))
                .frame(height: UIScreen.main.bounds.height)
            }
          )
        }
        .onDelete(perform: deleteItems)
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

  private func deleteItems(offsets: IndexSet) {
      withAnimation {
          for index in offsets {
              modelContext.delete(entries[index])
          }
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
    case .success:
      toast = Toast(style: .success, title: String(localized: "Success"), message: message, width: 160)
    case .info:
      toast = Toast(style: .info, title: String(localized: "Info"), message: message, duration: 10, width: 160)
    case .error:
      toast = Toast(style: .error, title: String(localized: "Error"), message: message, duration: 10, width: 160)
    }
  }
}

#Preview {
  ExpenseListView()
        .modelContainer(for: ExpenseEntry.self, inMemory: true)
        .environment(Constants())
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
