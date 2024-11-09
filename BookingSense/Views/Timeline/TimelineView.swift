// Created for BookingSense on 31.10.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TimelineView: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    @Bindable var appStates = appStates

    NavigationStack {
      TimelineContentListView()
      .navigationTitle("Timeline")
      .navigationBarTitleDisplayMode(.automatic)
      .toolbar {
        ToolbarTimelineContent()
      }
      .sheet(isPresented: $appStates.isTimeFilterDialogPresented) {
        TimeFilterDialog()
          .presentationDetents([.medium, .large])
      }
    }.searchable(text: $appStates.searchTimelineText, prompt: "Search")
  }
}
