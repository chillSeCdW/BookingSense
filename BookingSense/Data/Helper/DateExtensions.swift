// Created for BookingSense on 08.12.24 by kenny
// Using Swift 6.0
import Foundation

extension Date {
  func sectionTitleFormatting() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    dateFormatter.dateFormat = "MMMM yyyy"
    return dateFormatter.string(from: self)
  }

  func timelineEntryFormatting() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone(identifier: "UTC")
    formatter.setLocalizedDateFormatFromTemplate("EEE ddMMyyyy")
    return formatter.string(from: self)
  }

  func bookingEntryNextDateFormatting() -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    formatter.timeZone = TimeZone(identifier: "UTC")
    formatter.timeStyle = .none
    return formatter.string(from: self)
  }
}