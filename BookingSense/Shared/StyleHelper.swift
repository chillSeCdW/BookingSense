// Created for BookingSense on 27.01.25 by kenny
// Using Swift 6.0
import OSLog
import SwiftUI
import BookingSenseData

struct StyleHelper {
  static let logger = Logger(subsystem: "BookingSense", category: "StyleHelper")

  static var listBackgroundColors: [BookingType: Color] = [
    BookingType.plus: Color(red: 0.2039, green: 0.7373, blue: 0.2039), // green
    BookingType.minus: Color(red: 0.7882, green: 0, blue: 0.0118), // red
    BookingType.saving: Color(red: 44/255, green: 200/255, blue: 224/255) // blueish
  ]
  static var listBackgroundColorsInactive: [BookingType: Color] = [
    BookingType.plus: Color(red: 0.2039, green: 0.7373, blue: 0.2039, opacity: 0.3), // green
    BookingType.minus: Color(red: 0.7882, green: 0, blue: 0.0118, opacity: 0.3), // red
    BookingType.saving: Color(red: 44/255, green: 200/255, blue: 224/255, opacity: 0.3) // blueish
  ]
  static var getBackground: (ColorScheme) -> Color = { scheme in
    scheme == .light ? .white : Color(
        red: 64/255,
        green: 64/255,
        blue: 64/255,
        opacity: 1.0
    )// darkGrey
  }

  static func getListBackgroundColor(for bookingType: BookingType, isActive: Bool = true) -> Color? {
    if isActive {
      return StyleHelper.listBackgroundColors[bookingType]
    } else {
      return StyleHelper.listBackgroundColorsInactive[bookingType]
    }
  }
}
