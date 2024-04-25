//
//  ExpenseListView.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 27.03.24.
//

import SwiftUI
import SwiftData

struct ExpenseNavigationSplitView: View {
  @Environment(ViewInfo.self) var viewInfo
  @Environment(NavigationContext.self) private var navigationContext
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.editMode) private var editMode
  @Environment(\.modelContext) private var modelContext
  @Query private var entries: [ExpenseEntry]
  @State private var showingSheet = false
  @State private var text = ""

  var createToast: ((ToastStyle, String) -> Void)

  var body: some View {
    @Bindable var viewInfo = viewInfo
    @Bindable var navigationContext = navigationContext

    NavigationSplitView {
      List(selection: $navigationContext.selectedEntry) {
        ForEach(Interval.allCases) { option in
          EntriesListView(
            interval: option,
            createToast: createToast,
            searchName: viewInfo.searchText,
            sortParameter: viewInfo.sortParameter,
            sortOrder: viewInfo.sortOrder
          )
        }
      }
      .navigationTitle("Expenses")
      .searchable(text: $viewInfo.searchText)
      .toolbar {
        ToolbarEntriesList(deleteAllItems: deleteAllItems, addEntry: addEntry)
      }
    } detail: {
      ExpenseEntryView(expenseEntry: navigationContext.selectedEntry, showToast: createToast)
    }.sheet(isPresented: $showingSheet, content: {
      ExpenseEntryView(expenseEntry: navigationContext.selectedEntry, showToast: createToast)
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

#Preview {
  ExpenseNavigationSplitView { toastType, message in
    print(toastType)
    print(message)
  }
  .environment(ViewInfo())
  .environment(NavigationContext())
  .modelContainer(previewContainer)
}
