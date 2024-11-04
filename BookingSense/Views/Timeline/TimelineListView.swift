// Created for BookingSense on 04.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TimelineListView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.modelContext) private var modelContext
  @Query private var timelineEntries: [TimelineEntry]

  private var sortedKeys: [Date] {
    groupedEntries.keys.sorted()
  }

  private var groupedEntries: [Date: [TimelineEntry]] {
    Constants.groupEntriesByMonthAndYear(entries: timelineEntries)
  }

  init(searchText: Binding<String>, stateFilter: Set<TimelineEntryState>) {
    _timelineEntries = Query(
      filter: TimelineEntry.predicate(searchText.wrappedValue, stateFilter: stateFilter),
      sort: \.isDue,
      order: .forward
    )
  }

  var body: some View {
    List {
      FilterButtonsView()
      ForEach(sortedKeys, id: \.self) { date in
        TimelineSectionView(date: date, entriesForDate: groupedEntries[date] ?? [])
      }
    }
    .listSectionSpacing(.compact)
    .listRowSpacing(5)
    .animation(.easeInOut, value: groupedEntries)
  }
}

struct FilterButtonsView: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    HStack {
      ForEach(TimelineEntryState.allCases, id: \.self) { option in
        Spacer()
        Button(
          action: { appStates.toggleFilter(option) },
          label: { Text(option.description) }
        )
        .background(appStates.activeFilters.contains(option) ? Color.blue : Color.gray.opacity(0.2))
        .foregroundColor(.white)
        .cornerRadius(20)
        .buttonStyle(.bordered)
        Spacer()
      }
    }
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
