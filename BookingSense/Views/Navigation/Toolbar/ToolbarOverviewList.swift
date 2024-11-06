// Created for BookingSense on 26.06.24 by kenny
// Using Swift 5.0

import SwiftUI
import LocalAuthentication
import OSLog

struct ToolbarOverviewList: ToolbarContent {
  private let logger = Logger(subsystem: "BookingSense", category: "ToolbarOverviewList")

  @Environment(AppStates.self) var appStates
  @AppStorage("blurSensitive") var blurSensitive = false
  @AppStorage("biometricEnabled") var biometricEnabled = false

  var body: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button(action: toggleDisplaySensitiveInfo) {
        Image(systemName: blurSensitive ? "eye.slash" : "eye")
      }.contentTransition(.symbolEffect(.replace.downUp.byLayer))
    }
  }

  func toggleDisplaySensitiveInfo() {
    if biometricEnabled {
      appStates.authenticationActive = true
      BiometricHandler.shared.authenticateWithBiometrics { (success: Bool, error: Error?) in
        if success {
          withAnimation {
            blurSensitive.toggle()
          }
          appStates.authenticationActive = false
        } else {
          if let error = error as? LAError {
            switch error.code {
            case .userCancel, .systemCancel:
              logger.error("Authentication code userCance flailed with error: \(error.localizedDescription)")
            case .userFallback:
              logger.error("Authentication code userFallback failed with error: \(error.localizedDescription)")
            default:
              logger.error("Authentication failed with error: \(error.localizedDescription)")
            }
          }
        }
      }
    } else {
      withAnimation {
        blurSensitive.toggle()
      }
    }
  }
}
