// Created for BookingSense on 03.05.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData
import BookingSenseData

struct NavigationStackContentView: View {
  @Environment(AppStates.self) var appStates
  @Query private var entries: [BookingEntry]

  private var sortedKeys: [String] {
    groupedEntries.keys.sorted()
  }

  private var groupedEntries: [String: [BookingEntry]] {
    let groupedEntries = Constants.groupBookingsByInterval(entries: entries)
    return Constants.sortAndFilterBookings(
      bookings: groupedEntries,
      sortBy: appStates.sortBy,
      sortOrder: appStates.sortOrder,
      tagFilter: appStates.activeBookingTagFilters
    )
  }

  private var entriesCount: Int {
    groupedEntries.values.reduce(0, { count, entry in
      count + entry.count
    })
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
      ForEach(sortedKeys, id: \.self) { intervalKey in
        IntervalSectionView(
          interval: Interval(rawValue: intervalKey) ?? nil,
          entries: groupedEntries[intervalKey] ?? []
        )
      }
      if entriesCount < 1 {
        HStack {
          Spacer()
          VStack {
            Text("No entries found")
              .multilineTextAlignment(.center)
              .bold()
            Text("Press the + button to add an entry or adjust filters")
              .multilineTextAlignment(.center)
          }
          Spacer()
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
    .animation(.easeInOut, value: groupedEntries)
    .listRowSpacing(5)
  }
}

struct IntervalSectionView: View {
  var interval: Interval?
  var entries: [BookingEntry]

  var body: some View {
    if let intervalString = interval?.description.capitalized {
      Section(
        header: Text(intervalString),
        footer: Text(LocalizedStringKey("\(entries.count) entries"))
      ) {
        ForEach(entries, id: \.uuid) { entry in
          BookingSectionView(entry: entry)
        }
      }
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
                      StyleHelper.getListBackgroundColor(for: option) :
                        StyleHelper.getListBackgroundColor(for: option, isActive: false)
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
