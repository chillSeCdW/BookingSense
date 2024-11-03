// Created for BookingSense on 03.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TimelineContentListView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(AppStates.self) var appStates
  @Environment(\.modelContext) private var modelContext
  @Query private var timelineEntries: [TimelineEntry]

  @State var animationDelay = 0.5

  @State var listEmpty = false

  private var groupedEntries: [Date: [TimelineEntry]] {
    Constants.groupEntriesByMonthAndYear(entries: timelineEntries)
  }

  init(searchText: Binding<String>) {
    _timelineEntries = Query(
      filter: TimelineEntry.predicate(searchText.wrappedValue),
      sort: \.isDue,
      order: .forward
  )
  }

  var body: some View {
    NavigationStack {
      if timelineEntries.isEmpty {
        Text("No timeline entries found")
      } else {
        List {
          let sortedKeys = groupedEntries.keys.sorted()
          ForEach(sortedKeys, id: \.self) { date in
            Section(header: Text(sectionTitle(for: date))) {
              if let entriesForDate = groupedEntries[date] {
                ForEach(entriesForDate, id: \.uuid) { entry in
                  TimelineEntryView(timelineEntry: entry)
                    .listRowBackground(Constants.getListBackgroundView(
                      amountPrefix: entry.amountPrefix,
                      isActive: entry.state != .skipped,
                      colorScheme: colorScheme)
                    )
                }
              }
            }
          }
        }
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
