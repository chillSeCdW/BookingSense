// Created for BookingSense on 03.05.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData

struct NavigationStackContentView: View {
  @Environment(SearchInfo.self) var viewInfo
  @Query private var entries: [BookingEntry]
  @AppStorage("sortParameter") var sortParameter: SortParameter = .name
  @AppStorage("sortOrder") var sortOrder: SortOrderParameter = .reverse

  var isListEmpty: Bool

  @ViewBuilder
  var body: some View {
    if isListEmpty {
        Text("No entries available")
        Text("Press the + button to add an entry")
    } else {
      List {
        ForEach(Interval.allCases) { option in
          EntryListView(
            interval: option,
            searchName: viewInfo.searchText,
            sortParameter: sortParameter,
            sortOrder: sortOrder
          )
        }
        Section {} footer: {
          Text("Total bookings \(entries.count)")
        }
      }
    }
  }
}

#Preview("WithContent") {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return NavigationStackContentView(isListEmpty: false)
    .environment(SearchInfo())
    .modelContainer(factory.container)
}

#Preview("emptyContent") {
    NavigationStackContentView(isListEmpty: true)
    .environment(SearchInfo())
}
