// Created for BookingSense on 16.01.25 by kenny
// Using Swift 6.0

import WidgetKit
import AppIntents
import SwiftData
import BookingSenseData

struct ConfigIntent: WidgetConfigurationIntent {
  static var title: LocalizedStringResource { "Configuration" }
  static var description: IntentDescription { "Config for filtering bookings in Widget." }

  init(
    typeOfBookings: BookingSenseWidgetContentType = .all,
    checkBehaviour: BookingSenseWidgetCheckBehaviour = .today,
    showHeader: BookingSenseWidgetShowHeader = .show,
    colorToggle: BookingSenseWidgetColoredToggle = .colored
  ) {
      self.typeOfBookings = typeOfBookings
      self.checkBehaviour = checkBehaviour
      self.showHeader = showHeader
      self.colorToggle = colorToggle
  }

  init() {
  }

  @Parameter(title: "Filter for entries", default: BookingSenseWidgetContentType.all)
  var typeOfBookings: BookingSenseWidgetContentType

  @Parameter(title: "Tap action", default: BookingSenseWidgetCheckBehaviour.today)
  var checkBehaviour: BookingSenseWidgetCheckBehaviour

  @Parameter(title: "Show header of widget", default: BookingSenseWidgetShowHeader.show)
  var showHeader: BookingSenseWidgetShowHeader

  @Parameter(title: "Color toggle based on booking type", default: BookingSenseWidgetColoredToggle.colored)
  var colorToggle: BookingSenseWidgetColoredToggle

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

  static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Bookings type list")

  static let caseDisplayRepresentations: [BookingSenseWidgetContentType: DisplayRepresentation] = [
    .all: DisplayRepresentation(title: LocalizedStringResource("All")),
    .plus: DisplayRepresentation(title: LocalizedStringResource("Incoming")),
    .minus: DisplayRepresentation(title: LocalizedStringResource("Outgoing")),
    .saving: DisplayRepresentation(title: LocalizedStringResource("Saving"))
  ]
}

enum BookingSenseWidgetCheckBehaviour: String, AppEnum {
  case today
  case onTime

  static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Bookings check behaviour list")

  static let caseDisplayRepresentations: [BookingSenseWidgetCheckBehaviour: DisplayRepresentation] = [
    .today: DisplayRepresentation(title: LocalizedStringResource("Today")),
    .onTime: DisplayRepresentation(title: LocalizedStringResource("On time"))
  ]
}

enum BookingSenseWidgetShowHeader: String, AppEnum {
  case show
  case hide

  static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Show header of widget")

  static let caseDisplayRepresentations: [BookingSenseWidgetShowHeader: DisplayRepresentation] = [
    .show: DisplayRepresentation(title: LocalizedStringResource("Show")),
    .hide: DisplayRepresentation(title: LocalizedStringResource("Hide"))
  ]
}

enum BookingSenseWidgetColoredToggle: String, AppEnum {
  case colored
  case black

  static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Toggle color in widget")

  static let caseDisplayRepresentations: [BookingSenseWidgetColoredToggle: DisplayRepresentation] = [
    .colored: DisplayRepresentation(title: LocalizedStringResource("Colored")),
    .black: DisplayRepresentation(title: LocalizedStringResource("Black"))
  ]
}
