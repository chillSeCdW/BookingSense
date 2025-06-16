// Created for BookingSense on 16.06.25 by kenny
// Using Swift 6.0

import AppIntents

enum BookingSenseWidgetColoredToggle: String, AppEnum {
  case colored
  case black

  static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Toggle color in widget")

  static let caseDisplayRepresentations: [BookingSenseWidgetColoredToggle: DisplayRepresentation] = [
    .colored: DisplayRepresentation(title: LocalizedStringResource("Colored")),
    .black: DisplayRepresentation(title: LocalizedStringResource("Black"))
  ]
}
