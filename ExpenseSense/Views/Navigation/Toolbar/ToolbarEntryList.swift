//
//  ToolbarEntryList.swift
//  BookingSense
//
//  Created by kenny on 25.04.24.
//

import SwiftUI

struct ToolbarEntryList: ToolbarContent {
  @Environment(\.editMode) private var editMode

  @Binding var showingConfirmation: Bool
  var addEntry: () -> Void

  var body: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
        EditButton()
    }
    if editMode?.wrappedValue.isEditing == true {
      ToolbarItem(placement: .navigationBarLeading) {
        Button(action: showPopup) {
            Label("Delete All", systemImage: "trash")
        }
      }
    }
    ToolbarItem {
        Button(action: addEntry) {
            Label("Add Item", systemImage: "plus")
        }
    }
    ToolbarItem {
      withAnimation {
        SortButtonView()
      }
    }
  }

  func showPopup() {
    withAnimation {
      showingConfirmation = true
    }
  }
}
