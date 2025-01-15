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
       typeFilter: Set<BookingType> = []
  ) {
    _timelineEntries = Query(
      filter: TimelineEntry.predicate(
        searchText,
        stateFilter: stateFilter,
        typeFilter: typeFilter
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
        if let groupEntriesForMonth = groupedEntries[date] {
          TimelineSectionView(date: date, entriesForDate: groupEntriesForMonth)
        }
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
        ForEach(BookingType.allCases, id: \.self) { option in
          Button(
            action: { appStates.toggleTimeTypeFilter(option) },
            label: { Text(option.description) }
          )
          .background(appStates.activeTimeTypeFilters.contains(option) ?
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
  @Environment(AppStates.self) var appStates
  let date: Date
  let entriesForDate: [TimelineEntry]

  var totalSectionPlus: Decimal { entriesForDate.reduce(0) {
    if $1.bookingType == BookingType.plus.rawValue {
      return $0 + $1.amount
    }
    return $0
  }}

  var totalSectionMinus: Decimal { entriesForDate.reduce(0) {
    if $1.bookingType == BookingType.minus.rawValue {
      return $0 + $1.amount
    }
    return $0
  }}

  var totalSectionSaving: Decimal { entriesForDate.reduce(0) {
    if $1.bookingType == BookingType.saving.rawValue {
      return $0 + $1.amount
    }
    return $0
  }}

  var body: some View {
    Section(header: Text(date.sectionTitleFormatting()), footer: footerInfo) {
      ForEach(entriesForDate, id: \.uuid) { entry in
        TimelineEntryRow(entry: entry)
      }
    }
  }

  @ViewBuilder
  var footerInfo: some View {
    HStack(alignment: .center) {
      VStack {
        Text("sum of income")
        Text(totalSectionPlus.generateFormattedCurrency())
          .blur(radius: appStates.blurSensitive ? 5.0 : 0)
      }
      Spacer()
      VStack {
        Text("sum of costs")
        Text(totalSectionMinus.generateFormattedCurrency())
          .blur(radius: appStates.blurSensitive ? 5.0 : 0)
      }
      Spacer()
      VStack {
        Text("sum of savings")
        Text(totalSectionSaving.generateFormattedCurrency())
          .blur(radius: appStates.blurSensitive ? 5.0 : 0)
      }
    }
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
      bookingType: entry.bookingType,
      isActive: entry.state != TimelineEntryState.skipped.rawValue,
      colorScheme: colorScheme
    )
  }
}
