//
//  Constants.swift
//  BookingSense
//
//  Created by kenny on 27.03.24.
//

import SwiftUI
import SwiftData
import Foundation
import OSLog

struct Constants {
  static let logger = Logger(subsystem: "BookingSense", category: "Constants")

  static var listBackgroundColors: [AmountPrefix: Color] = [
    AmountPrefix.plus: Color(UIColor(red: 0.2039, green: 0.7373, blue: 0.2039, alpha: 1.0)), // green
    AmountPrefix.minus: Color(UIColor(red: 0.7882, green: 0, blue: 0.0118, alpha: 1.0)), // red
    AmountPrefix.saving: Color(UIColor(red: 44/255, green: 158/255, blue: 224/255, alpha: 1.0)) // blueish
  ]
  static var getBackground: (ColorScheme) -> Color = { scheme in
    scheme == .light ? .white : Color(
      uiColor: UIColor(
        red: 64/255,
        green: 64/255,
        blue: 64/255,
        alpha: 1.0
      ) // darkGrey
    )
  }

  static let mailTo = "hello@chillturtle.de"
  static let mailSubject = "feedback"

  static func convertToNoun(_ interval: Interval) -> String {
    switch interval {
    case .daily:
      return String(localized: "Day")
    case .weekly:
      return String(localized: "Week")
    case .biweekly:
      return String(localized: "Biweek")
    case .monthly:
      return String(localized: "month")
    case .quarterly:
      return String(localized: "Quarter")
    case .semiannually:
      return String(localized: "Half-year")
    case .annually:
      return String(localized: "Year")
    }
  }

  static func getTimesValue(from interval: Interval?, to targetInterval: Interval?) -> Decimal {
    guard let fromInterval = interval, let targetInterval = targetInterval else {
      return 0
    }
    if fromInterval == targetInterval {
      return 1
    }

    let conversionRates: [Interval: Decimal] = [
      .daily: 1,
      .weekly: 365/52,
      .biweekly: 365/26,
      .monthly: 365/12,
      .quarterly: 365/4,
      .semiannually: 365/2,
      .annually: 365
    ]

    guard let fromRate = conversionRates[fromInterval], let toRate = conversionRates[targetInterval] else {
      return 0
    }

    var tmp: Decimal
    var result = Decimal()
    var makeFraction = false

    if toRate > fromRate {
      tmp = toRate / fromRate
    } else {
      tmp = fromRate / toRate
      makeFraction = true
    }

    NSDecimalRound(&result, &tmp, 0, .bankers)

    if makeFraction {
      result = 1/result
    }

    return result
  }

  static func generateTimelineEntriesOf(_ context: ModelContext, entry: BookingEntry) {
    guard let entryInterval = Interval(rawValue: entry.interval) else {
      return
    }
    let dateOneYearInFuture = self.getDateOfOneYearInFuture()

    let entryDates = self.getDatesForEntries(entry.date, endDate: dateOneYearInFuture, interval: entryInterval)

    try? context.transaction {
      entryDates.forEach { dateEntry in
        let timelineEntry = TimelineEntry(state: .active,
                             name: entry.name,
                             amount: entry.amount,
                             amountPrefix: entry.amountPrefix,
                             isDue: dateEntry,
                             tag: entry.tag,
                             completedAt: nil
        )
        context.insert(timelineEntry)
      }
      do {
          try context.save()
      } catch {
        logger.error("error saving modelContext: \(error)")
      }
    }

  }

  // swiftlint:disable:next cyclomatic_complexity
  static func getDatesForEntries(_ startDate: Date, endDate: Date, interval: Interval) -> [Date] {
    var dates: [Date] = []
    var currentDate = startDate

    let calendar = Calendar.current

    while currentDate <= endDate {
      dates.append(currentDate)
      switch interval {
      case .daily:
        if let newDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
          currentDate = newDate
        }
      case .weekly:
        if let newDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate) {
          currentDate = newDate
        }
      case .biweekly:
        if let newDate = calendar.date(byAdding: .weekOfYear, value: 2, to: currentDate) {
          currentDate = newDate
        }
      case .monthly:
        if let newDate = calendar.date(byAdding: .month, value: 1, to: currentDate) {
          currentDate = newDate
        }
      case .quarterly:
        if let newDate = calendar.date(byAdding: .month, value: 3, to: currentDate) {
          currentDate = newDate
        }
      case .semiannually:
        if let newDate = calendar.date(byAdding: .month, value: 6, to: currentDate) {
          currentDate = newDate
        }
      case .annually:
        if let newDate = calendar.date(byAdding: .year, value: 1, to: currentDate) {
          currentDate = newDate
        }
      }
    }

    return dates
  }

  static func getDateOfOneYearInFuture() -> Date {
    let nextYear = Calendar.current.component(.year, from: .now) + 1
    let currentMonth = Calendar.current.component(.month, from: .now)
    let currentDay = Calendar.current.component(.day, from: .now)
    var components = DateComponents()
    components.year = nextYear
    components.month = currentMonth
    components.day = currentDay
    components.hour = 23
    components.minute = 59

    return Calendar.current.date(from: components)!
  }

  static func getSymbol(_ code: String) -> String? {
    let locale = NSLocale(localeIdentifier: code)
    return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
  }
}
