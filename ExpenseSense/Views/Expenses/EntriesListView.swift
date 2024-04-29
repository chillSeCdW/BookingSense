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

  init(interval: Interval,
       searchName: String = "",
       sortParameter: SortParameter = .amount,
       sortOrder: SortOrder = .reverse
  ) {
    self.interval = interval

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
  let factory = ContainerFactory(ExpenseEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return EntriesListView(interval: .annually)
    .modelContainer(factory.container)
}
