// Created for BookingSense on 03.05.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData

struct NavigationStackContentView: View {
  @Environment(AppStates.self) var appStates
  @Query private var entries: [BookingEntry]

  @State private var groupedEntries: [String: [BookingEntry]] = [:]
  @State private var entriesCount: Int = 0

  private func updateGroupedEntries() {
      let grouped = Constants.groupBookingsByInterval(entries: entries)
      groupedEntries = Constants.sortAndFilterBookings(
        bookings: grouped,
        sortBy: appStates.sortBy,
        sortOrder: appStates.sortOrder,
        tagFilter: appStates.activeBookingTagFilters
      )
      entriesCount = groupedEntries.values.reduce(0) { $0 + $1.count }
    }

  init(searchName: String = "",
       stateFilter: Set<BookingEntryState> = [],
       typeFilter: Set<BookingType> = []
  ) {
    _entries = Query(
      filter: BookingEntry.predicate(searchName: searchName,
                                     stateFilter: stateFilter,
                                     typeFilter: typeFilter)
    )
  }

  @ViewBuilder
  var body: some View {
    List {
      FilterBookingStateButtonsView()
      FilterBookingAmountButtonsView()
      ForEach(Interval.allCases) { option in
        IntervalSectionView(
          interval: option,
          entries: groupedEntries[option.rawValue] ?? []
        )
      }
      if entriesCount < 1 {
        VStack {
          Spacer()
          Text("No entries found")
            .bold()
          Text("Press the + button to add an entry or adjust filters")
        }
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
      } else {
        Section {} header: {
          Text("Total bookings \(entriesCount)")
        }
      }
    }
    .onChange(of: entries, initial: true) { _, _  in updateGroupedEntries() }
    .onChange(of: appStates.sortBy, initial: false) { _, _  in updateGroupedEntries() }
    .onChange(of: appStates.sortOrder, initial: false) { _, _  in updateGroupedEntries() }
    .onChange(of: appStates.activeBookingTagFilters, initial: false) { _, _ in updateGroupedEntries() }
    .animation(.easeInOut, value: groupedEntries)
    .listRowSpacing(5)
  }
}

struct IntervalSectionView: View {
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
        ForEach(BookingType.allCases, id: \.self) { option in
          Button(
            action: { appStates.toggleBookingTypeFilter(option) },
            label: { Text(option.description) }
          )
          .background(appStates.activeBookingTypeFilters.contains(option) ?
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
  let factory = ContainerFactory(BookingSchemaV4.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return NavigationStackContentView()
    .environment(AppStates())
    .modelContainer(factory.container)
}

#Preview("emptyContent") {
  NavigationStackContentView()
    .environment(AppStates())
}
