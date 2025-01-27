// Created for BookingSense on 16.01.25 by kenny
// Using Swift 6.0

import WidgetKit
import AppIntents
import SwiftData
import BookingSenseData

struct ConfigIntent: WidgetConfigurationIntent {
  static var title: LocalizedStringResource { "Configuration" }
  static var description: IntentDescription { "Config for filtering bookings in Widget." }

  init(typeOfBookings: BookingSenseWidgetContentType = .all) {
      self.typeOfBookings = typeOfBookings
  }

  init() {
  }

  @Parameter(title: "Type of bookings", default: BookingSenseWidgetContentType.minus)
  var typeOfBookings: BookingSenseWidgetContentType

  func buildPredicate() -> Predicate<BookingSchemaV5.TimelineEntry> {
    let typeFilterString = typeOfBookings.rawValue
    let stateFilterString = TimelineEntryState.open.rawValue

    switch typeOfBookings {
    case .all:
      return #Predicate {
        $0.state == stateFilterString
      }
    default:
      return #Predicate {
        $0.bookingType == typeFilterString &&
        $0.state == stateFilterString
      }
    }
  }
}

enum BookingSenseWidgetContentType: String, AppEnum {
  case all
  case plus
  case minus
  case saving

  static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "bookings type list")

  static let caseDisplayRepresentations: [BookingSenseWidgetContentType: DisplayRepresentation] = [
    .all: DisplayRepresentation(title: LocalizedStringResource("All")),
    .plus: DisplayRepresentation(title: LocalizedStringResource("Incoming")),
    .minus: DisplayRepresentation(title: LocalizedStringResource("Outgoing")),
    .saving: DisplayRepresentation(title: LocalizedStringResource("Saving"))
  ]
}
