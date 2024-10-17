// Created for BookingSense on 16.10.24 by kenny
// Using Swift 6.0

import Foundation

struct BookingEntryChartData {
  let id: String
  let name: String
  let amount: Decimal
}

enum ChartType: String, Codable, CaseIterable, Identifiable {
  var id: Self { self }

  case interval
  case total

  var description: String {
    switch self {
    case .interval:
      return "Interval"
    case .total:
      return "Total"
    }
  }
}
