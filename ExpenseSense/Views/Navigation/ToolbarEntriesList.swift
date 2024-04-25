//
//  ToolbarEntriesList.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 25.04.24.
//

import SwiftUI

struct ToolbarEntriesList: ToolbarContent {
  var deleteAllItems: () -> Void
  var addEntry: () -> Void

  var body: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
        EditButton()
    }
    ToolbarItem(placement: .navigationBarLeading) {
      DeleteAllButtonView {
        deleteAllItems()
      }
    }
    ToolbarItem {
        Button(action: addEntry) {
            Label("Add Item", systemImage: "plus")
        }
    }
    ToolbarItem {
      withAnimation {
        SortButton()
      }
    }
  }
}
