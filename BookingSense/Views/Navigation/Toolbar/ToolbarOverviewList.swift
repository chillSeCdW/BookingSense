// Created for BookingSense on 26.06.24 by kenny
// Using Swift 5.0

import SwiftUI
import LocalAuthentication
import OSLog

struct ToolbarOverviewList: ToolbarContent {
  private let logger = Logger(subsystem: "BookingSense", category: "ToolbarOverviewList")

  @Environment(AppStates.self) var appStates

  var body: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button(action: {
        Constants.toggleDisplaySensitiveInfo(
          appStates: appStates)
      }) {
        Image(systemName: appStates.blurSensitive ? "eye.slash" : "eye")
      }.contentTransition(.symbolEffect(.replace.downUp.byLayer))
    }
  }
}
