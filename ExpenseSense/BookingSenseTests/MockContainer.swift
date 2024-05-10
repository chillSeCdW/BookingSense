//
//  MockContainer.swift
//  BookingSenseTests
//
//  Created by kenny on 28.04.24.
//

import Foundation
import SwiftData
@testable import BookingSense

@MainActor
var mockContainer: ModelContainer {
  do {
    let container = try ModelContainer(
      for: BookingEntry.self,
      configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    return container
  } catch {
    fatalError("Failed to create mock container")
  }
}
