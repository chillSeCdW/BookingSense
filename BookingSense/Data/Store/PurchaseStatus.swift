// Created for BookingSense on 15.11.24 by kenny
// Using Swift 6.0

import StoreKit
import SwiftUI

enum PurchaseStatus: Comparable, Hashable {
  case defaultAccess
  case fullAccess

  init(levelOfService: Int) {
    self = switch levelOfService {
    case 1: .defaultAccess
    case 2: .fullAccess
    default: .defaultAccess
    }
  }

  init?(productID: Product.ID, ids: PurchaseIdentifiers) {
    switch productID {
    case ids.fullAccess: self = .fullAccess
    default: return nil
    }
  }
}

extension PurchaseStatus: CustomStringConvertible {

  var description: String {
    switch self {
    case .defaultAccess: String(localized: "Default Access")
    case .fullAccess: String(localized: "Full Access")
    }
  }

}
