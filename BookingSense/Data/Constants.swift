//
//  Constants.swift
//  BookingSense
//
//  Created by kenny on 27.03.24.
//

import SwiftUI
import SwiftData
import Foundation

struct Constants {
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

  // TODO: implement function
  static func generateTimelineEntryOf(entry: BookingEntry) -> TimelineEntry {

    return TimelineEntry(state: .active,
                         name: "entryName",
                         amount: .zero,
                         amountPrefix: .minus,
                         isDue: .distantFuture,
                         tag: nil,
                         completedAt: nil
    )
  }

  static func getSymbol(_ code: String) -> String? {
    let locale = NSLocale(localeIdentifier: code)
    return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
  }
}
