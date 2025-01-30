// Created for BookingSense on 31.10.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData
import WidgetKit
import BookingSenseData

struct TimelineView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(AppStates.self) var appStates

  @Query private var entries: [BookingEntry]

  var body: some View {
    @Bindable var appStates = appStates

    NavigationStack {
      ScrollViewReader { proxy in
        TimelineListView(
          searchText: appStates.searchTimelineText,
          stateFilter: appStates.activeTimeStateFilters,
          typeFilter: appStates.activeTimeTypeFilters
        )
        .navigationTitle("Timeline")
        .navigationBarTitleDisplayMode(.automatic)
        .searchable(text: $appStates.searchTimelineText, prompt: "Search")
        .refreshable {
          entries.forEach { entry in
            if entry.state == BookingEntryState.active.rawValue {
              let latestDate = Constants.getLatestTimelineEntryDueDateFor(entry)
              Constants.insertTimelineEntriesOf(entry,
                                                context: modelContext,
                                                latestTimelineDate: latestDate)
            }
          }
          WidgetCenter.shared.reloadTimelines(ofKind: "BookingTimeWidget")
        }
        .toolbar {
          ToolbarTimelineContent(proxy: proxy)
        }
        .sheet(isPresented: $appStates.isTimeFilterDialogPresented) {
          TimeFilterDialog()
            .presentationDetents([.medium, .large])
        }
      }
    }
  }
}
