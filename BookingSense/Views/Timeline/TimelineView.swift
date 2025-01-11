// Created for BookingSense on 31.10.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TimelineView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(AppStates.self) var appStates

  @Query private var entries: [BookingEntry]

  var body: some View {
    @Bindable var appStates = appStates

    NavigationStack {
      TimelineContentListView()
        .navigationTitle("Timeline")
        .navigationBarTitleDisplayMode(.automatic)
        .refreshable {
          entries.forEach { entry in
            if entry.state == BookingEntryState.active.rawValue {
              let latestDate = Constants.getLatestTimelineEntryDueDateFor(entry)
              Constants.insertTimelineEntriesOf(entry,
                                                context: modelContext,
                                                latestTimelineDate: latestDate)
            }
          }
        }
        .toolbar {
          ToolbarTimelineContent()
        }
        .sheet(isPresented: $appStates.isTimeFilterDialogPresented) {
          TimeFilterDialog()
            .presentationDetents([.medium, .large])
        }
    }
    .searchable(text: $appStates.searchTimelineText, prompt: "Search")
  }
}
