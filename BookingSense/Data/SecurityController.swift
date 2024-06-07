// Created for BookingSense on 07.06.24 by kenny
// Using Swift 5.0

import SwiftUI
import LocalAuthentication

@MainActor
class SecurityController: ObservableObject {

  var error: NSError?
  var setPasscode: String = "1234"

  @Published var isLocked = false
  @Published var isAppLockEnabled: Bool = UserDefaults.standard.object(forKey: "isAppLockEnabled") as? Bool ?? true

  func authenticate() {
    let context = LAContext()
    let reason = "Authenticate yourself to unlock BookingSense"
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
        Task { @MainActor in
          if success {
            self.isLocked = false
          } else {
            print(self.error?.localizedDescription)
            // enter password using system UI
          }
        }
      }
    }
  }

  func appLockStateChange(_ isEnabled: Bool) {
    let context = LAContext()
    let reason = "Authenticate to toggle App Lock"
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
      context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, _ in
        Task { @MainActor in
          if success {
            self.isLocked = false
            self.isAppLockEnabled = isEnabled
            UserDefaults.standard.set(self.isAppLockEnabled, forKey: "isAppLockEnabled")
          } else {
            print(self.error?.localizedDescription)
            // enter password using system UI
          }
        }
      }
    }
  }

  func showLockedViewIfEnabled() {
    if isAppLockEnabled {
      isLocked = true
      authenticate()
    } else {
      isLocked = false
    }
  }

  func lockApp() {
    if isAppLockEnabled {
      isLocked = true
    } else {
      isLocked = false
    }
  }
}
