// Created for BookingSense on 16.06.25 by kenny
// Using Swift 6.0

import Foundation
import SwiftUI
import BookingSenseData

@MainActor
@Observable
final class Navigator: ObservableObject {
  static let shared = Navigator()

  var selectedTab: NavigationTabOption = .statistics
  var stackPath: [BookingEntry] = []

  func navigate(to navigationOption: NavigationTabOption) {
    self.selectedTab = navigationOption
  }

  func navigate(to bookingEntry: BookingEntry) async {
    selectedTab = .bookings

    // Wait a little to ensure NavigationStack is loaded.
    do {
        try await Task.sleep(for: .seconds(0.25))
    } catch {
        print("Task sleep failed: \(error)")
    }

    stackPath.append(bookingEntry)
  }
}
