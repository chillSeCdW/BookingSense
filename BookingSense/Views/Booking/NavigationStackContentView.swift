// Created for BookingSense on 03.05.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData

struct NavigationStackContentView: View {
  @Environment(AppStates.self) var appStates
  @Query private var entries: [BookingEntry]

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
            searchName: appStates.searchText,
            sortParameter: appStates.sortBy,
            sortOrder: appStates.sortOrder
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
    .environment(AppStates())
    .modelContainer(factory.container)
}

#Preview("emptyContent") {
  NavigationStackContentView(isListEmpty: true)
    .environment(AppStates())
}
