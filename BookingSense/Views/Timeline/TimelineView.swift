// Created for BookingSense on 31.10.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData
import WidgetKit
import BookingSenseData

struct TimelineView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(AppStates.self) var appStates

  @State private var isGeneratingTimeline = false
  @State private var showDeleteAllConfirm = false
  @State private var showDeleteOpenConfirm = false

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
          guard !isGeneratingTimeline else { return }
          isGeneratingTimeline = true
          await generatedTimelineEntries()
          isGeneratingTimeline = false
        }
        .task {
          guard !isGeneratingTimeline else { return }
          isGeneratingTimeline = true
          await generatedTimelineEntries()
          isGeneratingTimeline = false
        }
        .toolbar {
          ToolbarTimelineContent(
            showDeleteAllConfirm: $showDeleteAllConfirm,
            showDeleteOpenConfirm: $showDeleteOpenConfirm,
            proxy: proxy
          )
        }
        .confirmationDialog("Are you sure?", isPresented: $showDeleteAllConfirm) {
          Button("Delete all timeline entries", role: .destructive, action: deleteAllItems)
        } message: {
          Text("Are you sure you want to delete all timeline entries?")
        }
        .confirmationDialog("Are you sure?", isPresented: $showDeleteOpenConfirm) {
          Button("Delete all open entries", role: .destructive, action: deleteAllOpenItems)
        } message: {
          Text("Are you sure you want to delete all open entries?")
        }
        .sheet(isPresented: $appStates.isTimeFilterDialogPresented) {
          TimeFilterDialog()
            .presentationDetents([.medium, .large])
        }
      }
    }
  }

  func generatedTimelineEntries() async {
    let activeEntries = entries.filter { $0.state == BookingEntryState.active.rawValue }
    guard !activeEntries.isEmpty else { return }

    for entry in activeEntries {
      await MainActor.run {
        let latestDate = Constants.getLatestTimelineEntryDueDateFor(entry)
        Constants.insertTimelineEntriesOf(entry,
                                          context: modelContext,
                                          latestTimelineDate: latestDate)
      }
    }
    WidgetCenter.shared.reloadTimelines(ofKind: "BookingTimeWidget")
  }

  private func deleteAllItems() {
    withAnimation {
      do {
        try modelContext.delete(model: TimelineEntry.self)
      } catch {
        print("Failed to delete all Timeline entries")
      }
    }
  }

  private func deleteAllOpenItems() {
    withAnimation {
      do {
        try modelContext.delete(model: TimelineEntry.self,
                                where: #Predicate { $0.completedAt == nil && $0.state == "open" }
        )
      } catch {
        print("Failed to delete all open Timeline entries")
      }
    }
  }

}
