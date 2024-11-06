// Created for BookingSense on 03.05.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData

struct NavigationStackContentView: View {
  @Environment(AppStates.self) var appStates
  @Query private var entries: [BookingEntry]

  private var groupedEntries: [String: [BookingEntry]] {
    let groupedEntries = Constants.groupBookingsByInterval(entries: entries)
    return Constants.sortBookings(
      bookings: groupedEntries,
      sortBy: appStates.sortBy,
      sortOrder: appStates.sortOrder
    )
  }

  init(searchName: String = "") {
    _entries = Query(
      filter: BookingEntry.predicate(searchName: searchName))
  }

  @ViewBuilder
  var body: some View {
    if entries.isEmpty {
      Text("No entries available")
      Text("Press the + button to add an entry")
    } else {
      List {
        ForEach(Interval.allCases) { option in
          IntervalSectionView(
            interval: option,
            entries: groupedEntries[option.rawValue] ?? []
          )
        }
        Section {} footer: {
          Text("Total bookings \(entries.count)")
        }
      }
      .animation(.easeInOut, value: groupedEntries)
      .listRowSpacing(5)
    }
  }
}

struct IntervalSectionView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.modelContext) private var modelContext

  var interval: Interval
  var entries: [BookingEntry]

  var body: some View {
    if !entries.isEmpty {
      Section(content: {
        BookingSectionView(entries: entries)
      }, header: {
        HStack {
          Text(interval.description.capitalized)
        }
      }, footer: {
        Text(LocalizedStringKey("\(entries.count) entries"))
      })
      .headerProminence(.increased)
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

#Preview("WithContent") {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return NavigationStackContentView()
    .environment(AppStates())
    .modelContainer(factory.container)
}

#Preview("emptyContent") {
  NavigationStackContentView()
    .environment(AppStates())
}
