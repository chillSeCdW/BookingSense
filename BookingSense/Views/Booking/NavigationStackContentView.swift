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

  init(searchName: String = "",
       stateFilter: Set<BookingEntryState> = [],
       prefixFilter: Set<AmountPrefix> = []
  ) {
    _entries = Query(
      filter: BookingEntry.predicate(searchName: searchName,
                                     stateFilter: stateFilter,
                                     prefixFilter: prefixFilter)
    )
  }

  @ViewBuilder
  var body: some View {
    List {
      FilterBookingStateButtonsView()
      FilterBookingAmountButtonsView()
      if entries.isEmpty {
        VStack {
          Text("No entries found")
          Text("Press the + button to add an entry or adjust filters")
        }
        .listRowBackground(Color.clear)
      }
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

struct FilterBookingStateButtonsView: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(BookingEntryState.allCases, id: \.self) { option in
          Button(
            action: { appStates.toggleBookingStateFilter(option) },
            label: { Text(option.description) }
          )
          .background(
            appStates.activeBookingStateFilters.contains(option) ? Color.blue : Color.gray.opacity(0.3)
          )
          .foregroundColor(.white)
          .cornerRadius(20)
          .buttonStyle(.bordered)
        }
      }
    }
    .listRowInsets(EdgeInsets())
    .listRowBackground(Color.clear)
  }
}

struct FilterBookingAmountButtonsView: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(AmountPrefix.allCases, id: \.self) { option in
          Button(
            action: { appStates.toggleBookingPrefixFilter(option) },
            label: { Text(option.description) }
          )
          .background(appStates.activeBookingPrefixFilters.contains(option) ?
                      Constants.getListBackgroundColor(for: option) :
                        Constants.getListBackgroundColor(for: option, isActive: false)
          )
          .foregroundColor(.white)
          .cornerRadius(20)
          .buttonStyle(.bordered)
        }
      }
    }
    .listRowInsets(EdgeInsets())
    .listRowBackground(Color.clear)
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
