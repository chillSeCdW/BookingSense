// Created for BookingSense on 31.10.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TimelineView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(AppStates.self) var appStates
  @Environment(\.modelContext) private var modelContext
  @Query private var timelineEntries: [TimelineEntry]

  init() {
    _timelineEntries = Query(
      filter: nil,
      sort: \.isDue,
      order: .forward
  )
  }

  var body: some View {
    NavigationStack {
      Form {
        ForEach(timelineEntries) { entry in
          Section(header: Text(entry.isDue.formatted(.dateTime
            .month(.wide)
            .year()))) {
              TimelineEntryView(timelineEntry: entry)
            }.listRowBackground(
              HStack(spacing: 0) {
                Rectangle()
                  .fill(Constants.listBackgroundColors[entry.amountPrefix]!)
                  .frame(width: 10)
                Rectangle()
                  .fill(Constants.getBackground(colorScheme))
              }
            )
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
