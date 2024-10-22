// Created for BookingSense on 22.10.24 by kenny
// Using Swift 6.0

import LocalAuthentication
import UIKit
import SwiftUICore

class BiometricHandler {
    static let shared = BiometricHandler()
    static var sharedError: NSError?

    func canUseAuthentication() -> Bool {
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: &BiometricHandler.sharedError)
    }

    func authenticateWithBiometrics(completion: @escaping (Bool, Error?) -> Void) {
        LAContext().evaluatePolicy(.deviceOwnerAuthentication,
                               localizedReason: "Authenticate using Face ID or Touch ID"
        ) { success, error in
          completion(success, error)
        }
    }
}
