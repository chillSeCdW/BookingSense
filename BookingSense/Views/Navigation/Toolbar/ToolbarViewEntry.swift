// Created for BookingSense on 08.12.24 by kenny
// Using Swift 6.0

import SwiftUI

struct ToolbarViewEntry: ToolbarContent {
  @Environment(AppStates.self) var appStates
  var edit: () -> Void

  @State private var showTooltip: Bool = false

  var body: some ToolbarContent {
    ToolbarItem {
      Button("Edit", systemImage: "pencil", action: edit)
        .disabled(appStates.blurSensitive)
    }
  }
}
