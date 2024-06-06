//
//  EntryListView.swift
//  BookingSense
//
//  Created by kenny on 02.05.24.
//

import SwiftUI
import SwiftData

struct EntryListView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.modelContext) private var modelContext
  @Query private var entries: [BookingEntry]

  var interval: Interval

  init(interval: Interval,
       searchName: String = "",
       sortParameter: SortParameter = .amount,
       sortOrder: SortOrder = .reverse
  ) {
    self.interval = interval

    switch sortParameter {
    case .name: _entries = Query(
      filter: BookingEntry.predicate(searchName: searchName, interval: interval),
      sort: \.name,
      order: sortOrder)
    case .amount: _entries = Query(
      filter: BookingEntry.predicate(searchName: searchName, interval: interval),
      sort: \.amount,
      order: sortOrder)
    }
  }

  var body: some View {
    if !entries.isEmpty {
      Section(content: {
        ForEach(entries) { entry in
          NavigationLink(value: entry) {
            HStack(spacing: 0) {
              Text(entry.name)
              Spacer()
              Text(entry.amount, format: .currency(code: Locale.current.currency!.identifier))
            }
          }.accessibilityIdentifier("NavLink" + entry.name)
          .listRowBackground(
            HStack(spacing: 0) {
              Rectangle()
                .fill(Constants.listBackgroundColors[entry.amountPrefix]!)
                .frame(width: 10)
              Rectangle()
                .fill(Constants.getBackground(colorScheme))
            }
          )
        }.onDelete(perform: deleteEntry)
      }, header: {
        HStack {
          Text(interval.description)
          Text("(" + entries.count.formatted() + " entries)")
        }

      })
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
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return EntryListView(interval: .annually)
    .modelContainer(factory.container)
}
