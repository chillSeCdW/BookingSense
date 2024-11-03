// Created for BookingSense on 03.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TimelineContentListView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(AppStates.self) var appStates
  @Environment(\.modelContext) private var modelContext
  @Query private var timelineEntries: [TimelineEntry]

  @State var listEmpty = false

  var body: some View {
    @Bindable var appStates = appStates
    
    NavigationStack {
      if timelineEntries.isEmpty {
        Text("No timeline entries found")
      } else {
        TimelineListView(
          searchText: $appStates.searchTimelineText,
          stateFilter: appStates.activeFilters
        )
      }
    }.onAppear {
      listEmpty = timelineEntries.isEmpty
    }
  }

  private func sectionTitle(for date: Date) -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MMMM yyyy"
          return dateFormatter.string(from: date)
      }
}
