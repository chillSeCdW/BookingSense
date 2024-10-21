//
//  BookingNavigationStackView.swift
//  BookingSense
//
//  Created by kenny on 02.05.24.
//

import SwiftUI
import SwiftData

struct BookingNavigationStackView: View {
  @Environment(SearchInfo.self) var viewInfo
  @Environment(\.editMode) private var editMode
  @Environment(\.modelContext) private var modelContext
  @Query private var entries: [BookingEntry]

  @State private var showingSheet = false
  @State private var showingConfirmation = false
  @State private var stackPath: [BookingEntry] = []

  var body: some View {
    @Bindable var viewInfo = viewInfo

    NavigationStack(path: $stackPath) {
      VStack {
        NavigationStackContentView(isListEmpty: entries.isEmpty)
          .navigationDestination(for: BookingEntry.self) { entry in
            EntryView(expenseEntry: entry)
          }
          .navigationTitle("Bookings")
          .navigationBarTitleDisplayMode(.automatic)
          .searchable(text: $viewInfo.searchText, prompt: "Search")
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
    }
    .sheet(isPresented: $showingSheet, content: {
      NavigationStack {
        EntryView()
          .presentationDetents([.medium, .large])
      }
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

#Preview("NavStackWithList") {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return BookingNavigationStackView()
    .environment(SearchInfo())
    .modelContainer(factory.container)
}

#Preview("NavStackWithoutList") {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  return BookingNavigationStackView()
    .environment(SearchInfo())
    .modelContainer(factory.container)
}
