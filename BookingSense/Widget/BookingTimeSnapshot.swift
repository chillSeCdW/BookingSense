// Created for BookingSense on 20.01.25 by kenny
// Using Swift 6.0

import Foundation
import OSLog
import SwiftData
import BookingSenseData

private let logger = Logger(subsystem: "BookingSenseWidget", category: "BookingTimeSnapshot")

public struct BookingTimeSnapshot: Hashable, Codable, Identifiable {
  public var id: String {
      uuid
  }

  let uuid: String
  let name: String
  let bookingType: String
  let amount: Decimal
  let isDue: Date
  var state: String
  var completedAt: Date?
}
