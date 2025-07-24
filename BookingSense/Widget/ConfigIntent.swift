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
