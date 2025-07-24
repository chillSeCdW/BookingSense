// Created for BookingSense on 16.06.25 by kenny
// Using Swift 6.0

import AppIntents

enum BookingSenseWidgetCheckBehaviour: String, AppEnum {
  case today
  case onTime

  static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Timeline check behaviour list")

  static let caseDisplayRepresentations: [BookingSenseWidgetCheckBehaviour: DisplayRepresentation] = [
    .today: DisplayRepresentation(title: LocalizedStringResource("Today")),
    .onTime: DisplayRepresentation(title: LocalizedStringResource("On time"))
  ]
}
