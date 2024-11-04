// Created for BookingSense on 04.11.24 by kenny
// Using Swift 6.0

import SwiftUI

enum SortOrderEnum: String, CaseIterable, Identifiable {
  case forward, reverse
  var id: Self { self }
  var name: String {
    let key = "sort_order.\(rawValue.lowercased())"
    return NSLocalizedString(key, comment: "")
  }
}
