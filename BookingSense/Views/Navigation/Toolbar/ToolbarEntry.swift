//
//  ToolbarEntry.swift
//  BookingSense
//
//  Created by kenny on 25.04.24.
//

import SwiftUI

struct ToolbarEntry: ToolbarContent {
  @Environment(\.dismiss) var dismiss

  var isCreate: Bool
  var save: () -> Void
  var didValuesChange: () -> Bool

  @Binding var showingConfirmation: Bool

  var body: some ToolbarContent {
    if isCreate {
      ToolbarItem(placement: .topBarLeading) {
        Button("Cancel") {
          dismiss()
        }
      }
      ToolbarItem {
        Button("Create", action: save)
      }
    } else {
      ToolbarItem {
        Button("Delete", systemImage: "trash", role: .destructive, action: showPopup)
          .tint(.red)
      }
      ToolbarItem {
        Button("Save", action: save)
          .disabled(!didValuesChange())
      }
    }
  }

  func showPopup() {
    withAnimation {
      showingConfirmation = true
    }
  }
}
