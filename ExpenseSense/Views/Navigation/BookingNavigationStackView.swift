//
//  BookingNavigationStackView.swift
//  BookingSense
//
//  Created by kenny on 02.05.24.
//

import SwiftUI
import SwiftData

struct BookingNavigationStackView: View {
  @Environment(ViewInfo.self) var viewInfo
  @Environment(\.editMode) private var editMode
  @Environment(\.modelContext) private var modelContext
  @Query private var entries: [BookingEntry]

  @State private var showingSheet = false
  @State private var showingConfirmation = false
  @State private var stackPath: [BookingEntry] = []

  var body: some View {
    @Bindable var viewInfo = viewInfo

    NavigationStack(path: $stackPath) {
      NavigationStackContentView(isListEmpty: entries.isEmpty)
        .navigationDestination(for: BookingEntry.self) { entry in
          EntryView(expenseEntry: entry)
        }
        .navigationTitle("Bookings")
        .searchable(text: $viewInfo.searchText, prompt: "Search")
        .toolbar {
          ToolbarEntryList(showingConfirmation: $showingConfirmation, addEntry: addEntry)
        }.confirmationDialog("Are you sure?", isPresented: $showingConfirmation) {
          Button("Delete all entries", action: deleteAllItems)
        } message: {
          Text("Are you sure you want to delete all entries?")
        }
    }
    .sheet(isPresented: $showingSheet, content: {
      NavigationStack {
        EntryView()
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
      entries.forEach { entry in
        modelContext.delete(entry)
      }
    }
  }
}

#Preview("NavStackWithList") {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return BookingNavigationStackView()
  .environment(ViewInfo())
  .environment(NavigationContext())
  .modelContainer(factory.container)
}

#Preview("NavStackWithoutList") {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  return BookingNavigationStackView()
  .environment(ViewInfo())
  .environment(NavigationContext())
  .modelContainer(factory.container)
}
