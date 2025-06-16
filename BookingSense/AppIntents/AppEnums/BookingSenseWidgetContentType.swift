// Created for BookingSense on 16.06.25 by kenny
// Using Swift 6.0

import AppIntents

enum BookingSenseWidgetContentType: String, AppEnum {
  case all
  case plus
  case minus
  case saving

  static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Bookings type list")

  static let caseDisplayRepresentations: [BookingSenseWidgetContentType: DisplayRepresentation] = [
    .all: DisplayRepresentation(title: LocalizedStringResource("All")),
    .plus: DisplayRepresentation(title: LocalizedStringResource("Incoming")),
    .minus: DisplayRepresentation(title: LocalizedStringResource("Outgoing")),
    .saving: DisplayRepresentation(title: LocalizedStringResource("Saving"))
  ]
}
