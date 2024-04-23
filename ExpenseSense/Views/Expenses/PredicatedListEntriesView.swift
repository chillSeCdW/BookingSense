//
//  PredicatedListEntriesView.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 22.04.24.
//

import SwiftUI
import SwiftData

struct PredicatedListEntriesView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.modelContext) private var modelContext
  @Query private var entries: [ExpenseEntry]

  var interval: Interval
  var createToast: ((ToastStyle, String) -> Void)

  init(interval: Interval, createToast: @escaping ((ToastStyle, String) -> Void)) {
    self.interval = interval
    self.createToast = createToast
    self._entries = Query(Constants.createDescriptor(interval: interval), animation: .default)
  }

  var body: some View {
    if !entries.isEmpty {
      Section(header: Text(interval.description)) {
        ForEach(entries) { entry in
          NavigationLink {
            ExpenseEntryView(expenseEntry: entry) { toastType, message in
              createToast(toastType, message)
            }
          } label: {
            HStack(spacing: 0) {
              Text(entry.name)
              Spacer()
              Text(entry.amountPrefix.description)
              Text(entry.amount, format: .currency(code: Locale.current.currency!.identifier))
            }
          }
          .listRowBackground(
            HStack(spacing: 0) {
              Rectangle()
                .fill(Constants.listBackgroundColors[entry.amountPrefix]!)
                .frame(width: 10, height: 50)
              Rectangle()
                .fill(Constants.getBackground(colorScheme))
                .frame(height: 50)
            }
          )
        }.onDelete(perform: deleteEntry)
      }
    }
  }

  private func deleteEntry(offsets: IndexSet) {
      withAnimation {
          for index in offsets {
              modelContext.delete(entries[index])
          }
      }
  }
}

#Preview {
  PredicatedListEntriesView(interval: .annually) { toastType, message in
    switch toastType {
    default:
      print(toastType)
      print(message)
    }
  }.modelContainer(previewContainer)
}
