// Created for BookingSense on 03.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TimelineContentListView: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    @Bindable var appStates = appStates

    NavigationStack {
      TimelineListView(
        searchText: appStates.searchTimelineText,
        stateFilter: appStates.activeTimeStateFilters,
        typeFilter: appStates.activeTimeTypeFilters
      )
    }
  }

  private func sectionTitle(for date: Date) -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MMMM yyyy"
          return dateFormatter.string(from: date)
      }
}
