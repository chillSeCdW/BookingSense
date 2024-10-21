//
//  ToolbarEntryList.swift
//  BookingSense
//
//  Created by kenny on 25.04.24.
//

import SwiftUI

struct ToolbarEntryList: ToolbarContent {
  @Environment(\.editMode) private var editMode
  @AppStorage("blurSensitive") var blurSensitive = false

  @Binding var showingConfirmation: Bool
  var addEntry: () -> Void

  var body: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button(action: toggleDisplaySensitiveInfo) {
        Image(systemName: blurSensitive ? "eye.slash" : "eye")
      }.contentTransition(.symbolEffect(.replace.downUp.byLayer))
    }
    if editMode?.wrappedValue.isEditing == true {
      ToolbarItem(placement: .navigationBarLeading) {
        Button("Delete all", systemImage: "trash", role: .destructive, action: showPopup).tint(.red)
      }
    }
    ToolbarItem {
      Button("Plus", systemImage: "plus", action: addEntry)
      .popoverTip(ToolbarAddTip())
    }
    ToolbarItem {
      withAnimation {
        SortButtonView()
      }
    }
    ToolbarItem(placement: .navigationBarTrailing) {
      EditButton()
    }
  }

  func showPopup() {
    withAnimation {
      showingConfirmation = true
    }
  }

  func toggleDisplaySensitiveInfo() {
    blurSensitive.toggle()
  }
}
