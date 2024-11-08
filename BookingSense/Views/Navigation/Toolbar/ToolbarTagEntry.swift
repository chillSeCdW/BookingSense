// Created for BookingSense on 08.11.24 by kenny
// Using Swift 6.0

import SwiftUI

struct ToolbarTagEntry: ToolbarContent {
  @Environment(\.dismiss) var dismiss

  var save: () -> Void

  var body: some ToolbarContent {
      ToolbarItem(placement: .topBarLeading) {
        Button("Cancel") {
          dismiss()
        }
      }
      ToolbarItem {
        Button("Create", action: save)
      }
  }
}
