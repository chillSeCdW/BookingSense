// Created for BookingSense on 15.11.24 by kenny
// Using Swift 6.0

import SwiftUI

public struct PurchaseIdentifiers: Sendable {
    public var fullAccess: String
}

public extension EnvironmentValues {

    private enum PurchaseIDsKey: EnvironmentKey {
        static var defaultValue = PurchaseIdentifiers(
            fullAccess: "com.chill.BookingSense.fullAccess"
        )
    }

    var accessIDs: PurchaseIdentifiers {
        get { self[PurchaseIDsKey.self] }
        set { self[PurchaseIDsKey.self] = newValue }
    }

}
