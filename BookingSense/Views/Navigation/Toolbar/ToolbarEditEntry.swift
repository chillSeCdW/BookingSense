//
//  ToolbarEntry.swift
//  BookingSense
//
//  Created by kenny on 25.04.24.
//

import SwiftUI

struct ToolbarEditEntry: ToolbarContent {
  var isCreate: Bool
  var save: () -> Void
  var didValuesChange: () -> Bool
  var dismissSheet: () -> Void

  var body: some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      Button("Cancel", action: dismissSheet)
    }
    if isCreate {
      ToolbarItem {
        Button("Create", action: save)
      }
    } else {
      ToolbarItem {
        Button("Save", action: save)
          .disabled(!didValuesChange())
      }
    }
  }
}
