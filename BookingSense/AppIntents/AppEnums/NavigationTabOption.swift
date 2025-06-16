// Created for BookingSense on 16.06.25 by kenny
// Using Swift 6.0

import AppIntents
import SwiftUI

enum NavigationTabOption: String, Hashable, Identifiable, CaseIterable, AppEnum {
  case statistics
  case timeline
  case bookings
  case settings

  static var typeDisplayRepresentation: TypeDisplayRepresentation {
    return TypeDisplayRepresentation(
      name: LocalizedStringResource("Navigation Option", table: "AppIntents"),
      numericFormat: "\(placeholder: .int) navigation options"
    )
  }

  static let caseDisplayRepresentations = [
    NavigationTabOption.statistics: DisplayRepresentation(
      title: "Statistics",
      image: .init(systemName: "chart.xyaxis.line")
    ),
    NavigationTabOption.timeline: DisplayRepresentation(
      title: "Timeline",
      image: .init(systemName: "calendar.day.timeline.left")
    ),
    NavigationTabOption.bookings: DisplayRepresentation(
      title: "Bookings",
      image: .init(systemName: "list.dash")
    ),
    NavigationTabOption.settings: DisplayRepresentation(
      title: "Settings",
      image: .init(systemName: "gear")
    )
  ]

  var id: String { rawValue }
}
