// Created for BookingSense on 03.05.24 by kenny
// Using Swift 5.0

import SwiftUI

struct NavigationStackContentView: View {
  @Environment(ViewInfo.self) var viewInfo

  var isListEmpty: Bool

  @ViewBuilder
  var body: some View {
    @Bindable var viewInfo = viewInfo

    if isListEmpty {
        Text("No entries available")
        Text("Press the + button to add an entry")
    } else {
      List {
        ForEach(Interval.allCases) { option in
          EntryListView(
            interval: option,
            searchName: viewInfo.searchText,
            sortParameter: viewInfo.sortParameter,
            sortOrder: viewInfo.sortOrder
          )
        }
      }
    }
  }
}

#Preview("WithContent") {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return NavigationStackContentView(isListEmpty: false)
    .environment(ViewInfo())
    .environment(NavigationContext())
    .modelContainer(factory.container)
}

#Preview("emptyContent") {
    NavigationStackContentView(isListEmpty: true)
    .environment(ViewInfo())
}
