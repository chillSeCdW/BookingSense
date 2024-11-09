// Created for BookingSense on 03.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import LocalAuthentication
import OSLog

struct ToolbarTimelineContent: ToolbarContent {
  private let logger = Logger(subsystem: "BookingSense", category: "ToolbarTimelineContent")

  @Environment(AppStates.self) var appStates

  var body: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button(action: {
        Constants.toggleDisplaySensitiveInfo(
          appStates: appStates)
      }, label: {
        Image(systemName: appStates.blurSensitive ? "eye.slash" : "eye")
      })
      .contentTransition(.symbolEffect(.replace.downUp.byLayer))
    }
    ToolbarItem(placement: .navigationBarTrailing) {
      Button(action: { appStates.isTimeFilterDialogPresented.toggle()},
             label: { Image(systemName: "line.horizontal.3.decrease.circle") }
      )
    }
  }
}
