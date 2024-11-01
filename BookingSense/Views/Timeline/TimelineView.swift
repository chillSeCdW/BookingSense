// Created for BookingSense on 31.10.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TimelineView: View {
  @Environment(AppStates.self) var appStates
  @Environment(\.modelContext) private var modelContext
  @Query private var timelineEntries: [TimelineEntry]

  var body: some View {
    NavigationStack {
      List {
        Section(header: Text(Date.now.formatted(.dateTime
          .month(.wide)
          .year()))) {
            ForEach(timelineEntries) { entry in
              Text(entry.uuid)
            }
        }
      }
      .navigationTitle("Timeline")
      .listStyle(.sidebar)
      .toolbar {
        ToolbarOverviewList()
      }
    }
  }
}
