// Created for BookingSense on 31.10.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TimelineView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(AppStates.self) var appStates

  @Query private var entries: [BookingEntry]

  @AppStorage("purchasedFullAccessUnlock") var fullAccess = false

  var body: some View {
    @Bindable var appStates = appStates

    NavigationStack {
      TimelineContentListView()
        .disabled(!fullAccess)
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
        .overlay(alignment: .center) {
          FullAccessTextOverlay()
        }
    }
    .searchable(text: $appStates.searchTimelineText, prompt: "Search")
  }
}

struct FullAccessTextOverlay: View {
  @AppStorage("purchasedFullAccessUnlock") var fullAccess = false

  var body: some View {
    if !fullAccess {
      ZStack {
        Rectangle()
          .fill(Color(.systemGray6))
          .border(Color(.systemGray), width: 5)
          .frame(maxHeight: 300)
          .opacity(0.8)
        VStack {
          Text("Timeline is a Full Access feature")
            .bold()
            .font(.title3)
            .padding(.bottom)
          Text("Timeline is there to help you keep track of your bookings")
          Text("Can remove this tab in settings if you don't want to use it")
          Text("Unlock feature in Settings -> Features")
            .italic()
            .padding(.top, 5)
        }
        .padding(.horizontal)
        .multilineTextAlignment(.center)
      }
    }
  }
}
