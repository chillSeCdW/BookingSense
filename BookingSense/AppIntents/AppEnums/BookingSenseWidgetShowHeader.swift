// Created for BookingSense on 16.06.25 by kenny
// Using Swift 6.0

import AppIntents

enum BookingSenseWidgetShowHeader: String, AppEnum {
  case show
  case hide

  static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Show header of widget")

  static let caseDisplayRepresentations: [BookingSenseWidgetShowHeader: DisplayRepresentation] = [
    .show: DisplayRepresentation(title: LocalizedStringResource("Show")),
    .hide: DisplayRepresentation(title: LocalizedStringResource("Hide"))
  ]
}
