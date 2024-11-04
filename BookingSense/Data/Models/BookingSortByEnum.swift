// Created for BookingSense on 04.11.24 by kenny
// Using Swift 6.0

import SwiftUI

enum SortByEnum: String, CaseIterable, Identifiable {
  case name, amount
  var id: Self { self }
  var name: String {
    let key = "sort_parameter.\(rawValue.lowercased())"
    return NSLocalizedString(key, comment: "")
  }
}
