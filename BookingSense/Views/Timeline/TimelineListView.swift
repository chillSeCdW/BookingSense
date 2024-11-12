// Created for BookingSense on 04.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TimelineListView: View {
  @Environment(AppStates.self) var appStates
  @Query private var timelineEntries: [TimelineEntry]

  private var sortedKeys: [Date] {
    groupedEntries.keys.sorted()
  }

  private var groupedEntries: [Date: [TimelineEntry]] {
    Constants.groupEntriesByMonthAndYearAndFilter(
      entries: timelineEntries,
      tagFilter: appStates.activeTimeTagFilters
    )
  }

  init(searchText: String = "",
       stateFilter: Set<TimelineEntryState> = [],
       prefixFilter: Set<AmountPrefix> = []
  ) {
    _timelineEntries = Query(
      filter: TimelineEntry.predicate(
        searchText,
        stateFilter: stateFilter,
        prefixFilter: prefixFilter
      ),
      sort: \.isDue,
      order: .forward
    )
  }

  var body: some View {
    List {
      FilterStateButtonsView()
      FilterAmountButtonsView()
      ForEach(sortedKeys, id: \.self) { date in
        TimelineSectionView(date: date, entriesForDate: groupedEntries[date] ?? [])
      }
      if groupedEntries.isEmpty {
        HStack {
          Spacer()
          Text("No timeline entries found")
            .multilineTextAlignment(.center)
          Spacer()
        }
        .listRowBackground(Color.clear)
      }
    }
    .listSectionSpacing(.compact)
    .listRowSpacing(5)
    .animation(.easeInOut, value: groupedEntries)
  }
}

struct FilterStateButtonsView: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(TimelineEntryState.allCases, id: \.self) { option in
          Button(
            action: { appStates.toggleTimeStateFilter(option) },
            label: { Text(option.description) }
          )
          .background(
            appStates.activeTimeStateFilters.contains(option) ? Color.blue : Color.gray.opacity(0.3)
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

struct FilterAmountButtonsView: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(AmountPrefix.allCases, id: \.self) { option in
          Button(
            action: { appStates.toggleTimePrefixFilter(option) },
            label: { Text(option.description) }
          )
          .background(appStates.activeTimePrefixFilters.contains(option) ?
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

struct TimelineSectionView: View {
  let date: Date
  let entriesForDate: [TimelineEntry]

  var body: some View {
    Section(header: Text(sectionTitle(for: date))) {
      ForEach(entriesForDate, id: \.uuid) { entry in
        TimelineEntryRow(entry: entry)
      }
    }
  }

  private func sectionTitle(for date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM yyyy"
    return dateFormatter.string(from: date)
  }
}

struct TimelineEntryRow: View {
  @Environment(\.colorScheme) var colorScheme
  let entry: TimelineEntry

  var body: some View {
    TimelineEntryView(timelineEntry: entry)
      .listRowBackground(rowBackgroundView)
  }

  private var rowBackgroundView: some View {
    Constants.getListBackgroundView(
      amountPrefix: entry.amountPrefix,
      isActive: entry.state != TimelineEntryState.skipped.rawValue,
      colorScheme: colorScheme
    )
  }
}
