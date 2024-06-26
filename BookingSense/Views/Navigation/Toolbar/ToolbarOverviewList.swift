// Created for BookingSense on 26.06.24 by kenny
// Using Swift 5.0

import SwiftUI

struct ToolbarOverviewList: ToolbarContent {
  @AppStorage("blurSensitive") var blurSensitive = false

  var body: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button(action: toggleDisplaySensitiveInfo) {
        Image(systemName: blurSensitive ? "eye.slash" : "eye")
      }.contentTransition(.symbolEffect(.replace.downUp.byLayer))
    }
  }

  func toggleDisplaySensitiveInfo() {
    blurSensitive.toggle()
  }
}
