//
//  BookingNavigationStackView.swift
//  BookingSense
//
//  Created by kenny on 02.05.24.
//

import SwiftUI
import SwiftData
import BookingSenseData

struct BookingNavigationStackView: View {
  @Environment(AppStates.self) var appStates
  @Environment(\.editMode) private var editMode
  @Environment(\.modelContext) private var modelContext

  @State private var showingSheet = false
  @State private var showingConfirmation = false
  @State private var stackPath: [BookingEntry] = []

  var body: some View {
    @Bindable var appStates = appStates

    NavigationStack(path: $stackPath) {
      NavigationStackContentView(
        searchName: appStates.searchText,
        stateFilter: appStates.activeBookingStateFilters,
        typeFilter: appStates.activeBookingTypeFilters
      )
      .navigationDestination(for: BookingEntry.self) { entry in
        EntryView(bookingEntry: entry)
      }
      .navigationTitle("Bookings")
      .navigationBarTitleDisplayMode(.automatic)
      .searchable(text: $appStates.searchText, prompt: "Search")
      .toolbar {
        ToolbarEntryList(showingConfirmation: $showingConfirmation, addEntry: addEntry)
      }
      .confirmationDialog("Are you sure?", isPresented: $showingConfirmation) {
        Button("Delete all entries", role: .destructive, action: deleteAllItems)
      } message: {
        Text("Are you sure you want to delete all entries?")
      }
      .environment(\.editMode, editMode)
    }
    .sheet(isPresented: $appStates.isBookingFilterDialogPresented) {
      BookingFilterDialog()
        .presentationDetents([.medium, .large])
    }
    .sheet(isPresented: $showingSheet, content: {
      EntryEditView()
    })
  }

  private func addEntry() {
    withAnimation {
      showingSheet.toggle()
    }
  }

  private func deleteAllItems() {
    withAnimation {
      do {
        try modelContext.delete(model: BookingEntry.self)
      } catch {
        print("Failed to delete all Booking entries")
      }
    }
  }
}

#if DEBUG
#Preview {
  let modelContainer = DataModel.shared.previewContainer
  return BookingNavigationStackView()
    .environment(AppStates())
    .modelContainer(modelContainer)
}
#endif
