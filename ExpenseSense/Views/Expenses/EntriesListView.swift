//
//  EntriesListView.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 24.04.24.
//

import SwiftUI
import SwiftData

struct EntriesListView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.modelContext) private var modelContext
  @Query private var entries: [ExpenseEntry]

  var interval: Interval
  var createToast: ((ToastStyle, String) -> Void)

  init(interval: Interval,
       createToast: @escaping ((ToastStyle, String) -> Void),
       searchName: String = "",
       sortParameter: SortParameter = .amount,
       sortOrder: SortOrder = .reverse
  ) {
    self.interval = interval
    self.createToast = createToast

    switch sortParameter {
    case .name: _entries = Query(
      filter: ExpenseEntry.predicate(searchName: searchName, interval: interval),
      sort: \.name,
      order: sortOrder)
    case .amount: _entries = Query(
      filter: ExpenseEntry.predicate(searchName: searchName, interval: interval),
      sort: \.amount,
      order: sortOrder)
    }
  }

  var body: some View {
    if !entries.isEmpty {
      Section(header: Text(interval.description)) {
        ForEach(entries) { entry in
          NavigationLink(value: entry) {
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
  EntriesListView(interval: .annually) { toastType, message in
    switch toastType {
    default:
      print(toastType)
      print(message)
    }
  }.modelContainer(previewContainer)
}
