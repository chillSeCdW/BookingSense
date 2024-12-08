// Created for BookingSense on 08.12.24 by kenny
// Using Swift 6.0

import SwiftUI

struct ToolbarViewEntry: ToolbarContent {
  var edit: () -> Void

  var body: some ToolbarContent {
    ToolbarItem {
      Button("Edit", systemImage: "pencil", action: edit)
    }
  }
}
