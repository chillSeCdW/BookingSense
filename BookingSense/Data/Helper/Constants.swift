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
import LocalAuthentication

// swiftlint:disable type_body_length
// swiftlint:disable file_length
struct Constants {
  static let logger = Logger(subsystem: "BookingSense", category: "Constants")

  static var listBackgroundColors: [BookingType: Color] = [
    BookingType.plus: Color(UIColor(red: 0.2039, green: 0.7373, blue: 0.2039, alpha: 1.0)), // green
    BookingType.minus: Color(UIColor(red: 0.7882, green: 0, blue: 0.0118, alpha: 1.0)), // red
    BookingType.saving: Color(UIColor(red: 44/255, green: 200/255, blue: 224/255, alpha: 1.0)) // blueish
  ]
  static var listBackgroundColorsInactive: [BookingType: Color] = [
    BookingType.plus: Color(UIColor(red: 0.2039, green: 0.7373, blue: 0.2039, alpha: 0.3)), // green
    BookingType.minus: Color(UIColor(red: 0.7882, green: 0, blue: 0.0118, alpha: 0.3)), // red
    BookingType.saving: Color(UIColor(red: 44/255, green: 200/255, blue: 224/255, alpha: 0.3)) // blueish
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

  static func getListBackgroundColor(for bookingType: BookingType, isActive: Bool = true) -> Color? {
    if isActive {
      return Constants.listBackgroundColors[bookingType]
    } else {
      return Constants.listBackgroundColorsInactive[bookingType]
    }
  }

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

  static func calculateCostOf(_ entry: BookingEntry, to toInterval: Interval) -> Decimal {
    let curInterval = Interval(rawValue: entry.interval)
    return entry.amount * getTimesValue(from: curInterval, to: toInterval)
  }

  static func calculateCostOf(entryInterval: Interval, entryAmount: Decimal, to toInterval: Interval) -> Decimal {
    return entryAmount * getTimesValue(from: entryInterval, to: toInterval)
  }

  static func getLatestTimelineEntryDueDateFor(_ entry: BookingEntry) -> Date? {
    let latestTimelineEntry = entry.timelineEntries?.sorted(by: {$0.isDue > $1.isDue}).first

    if let latestTimelineEntry {
      return latestTimelineEntry.isDue
    }
    return nil
  }

  static func calculateOneIntervalTimeDifference(_ interval: Interval) -> Double {
    let multiplier: Double
    switch interval {
    case .daily:
      multiplier = 1
    case .weekly:
      multiplier = 7
    case .biweekly:
      multiplier = 14
    case .monthly:
      multiplier = 30
    case .quarterly:
      multiplier = 90
    case .semiannually:
      multiplier = 180
    case .annually:
      multiplier = 365
    }
    return 86400 * multiplier // 60 * 60 * 24 = 86400 one day
  }

  static func insertTimelineEntriesOf(_ entry: BookingEntry, context: ModelContext, latestTimelineDate: Date? = nil) {
    guard let entryDate = entry.date else { return }
    var adjustingStartDate: Bool = false

    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!

    if let latestTimelineDate {
      if calendar.compare(latestTimelineDate, to: entryDate, toGranularity: .day) == .orderedAscending {
        adjustingStartDate = true // use bookingEntry date as starting date
      }
    }
    let originalDay = calendar.dateComponents([.day, .hour], from: entryDate)
    let dayOfEntry = calendar.dateComponents([.day], from: entryDate).day!
    let nextTimelineEntry = Constants.getNextDateOfInterval(
      latestTimelineDate,
      interval: entry.interval,
      searchComponents: originalDay,
      dayOfEntry: dayOfEntry
    )
    let timelineEntryList = generateTimelineEntriesFrom(bookingEntry: entry,
                                                        entryDate: entryDate,
                                                        startDate: adjustingStartDate ? nil : nextTimelineEntry,
                                                        dayOfEntry: dayOfEntry

    )

    try? context.transaction {
      timelineEntryList?.forEach { timelineEntry in
        context.insert(timelineEntry)
      }
    }
  }

  static func generateTimelineEntriesFrom(bookingEntry: BookingEntry,
                                          entryDate: Date,
                                          startDate: Date? = nil,
                                          dayOfEntry: Int
  ) -> [TimelineEntry]? {
    let dateOneYearInFuture = getDateOfOneYearInFuture()

    let entryDates = self.getDatesForEntries(startDate ?? entryDate,
                                             endDate: dateOneYearInFuture,
                                             interval: bookingEntry.interval,
                                             dayOfEntry: dayOfEntry
    )

    var timelineEntriesList: [TimelineEntry] = []

    entryDates.forEach { dateEntry in
      let timelineEntry = TimelineEntry(
        state: TimelineEntryState.open.rawValue,
        name: bookingEntry.name,
        amount: bookingEntry.amount,
        bookingType: bookingEntry.bookingType,
        isDue: dateEntry,
        tag: bookingEntry.tag,
        completedAt: nil,
        bookingEntry: bookingEntry
      )
      timelineEntriesList.append(timelineEntry)
    }

    return timelineEntriesList
  }

  static func removeTimelineEntriesFrom(_ entry: BookingEntry, context: ModelContext) {
    entry.timelineEntries?.forEach { entry in
      context.delete(entry)
    }
  }

  static func removeTimelineEntriesNewerThan(_ entry: BookingEntry, context: ModelContext) {
    guard let entryDate = entry.date else { return }
    let timelineEntriesList = entry.timelineEntries?.filter {
      $0.isDue >= entryDate
    }.sorted(by: {$0.isDue < $1.isDue})

    timelineEntriesList?.forEach { entry in
      context.delete(entry)
    }
  }

  static func removeTimelineEntriesNewerThan(_ date: Date, entry: BookingEntry, context: ModelContext) {
    let timelineEntriesList = entry.timelineEntries?.filter {
      $0.isDue >= date
    }.sorted(by: {$0.isDue < $1.isDue})

    timelineEntriesList?.forEach { entry in
      context.delete(entry)
    }
  }

  static func getDatesForEntries(_ startDate: Date, endDate: Date, interval: String, dayOfEntry: Int) -> [Date] {
    var dates: [Date] = []
    var currentDate = startDate
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!

    let originalDay = calendar.dateComponents([.day, .hour], from: startDate)

    while calendar.compare(currentDate, to: endDate, toGranularity: .day) == .orderedAscending {
      print("currentDate: \(currentDate)")
      dates.append(currentDate)
      if let newDate = getNextDateOfInterval(
        currentDate,
        interval: interval,
        searchComponents: originalDay,
        dayOfEntry: dayOfEntry
      ) {
        print("setting currentDate to \(newDate)")
        currentDate = newDate
      }
    }
    return dates
  }

  // swiftlint:disable:next cyclomatic_complexity
  static func getNextDateOfInterval(_ startDate: Date?,
                                    interval: String,
                                    searchComponents: DateComponents,
                                    dayOfEntry: Int) -> Date? {
    guard let startDate, let entryInterval = Interval(rawValue: interval) else {
      return nil
    }
    var nextDate: Date?

    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!

    switch entryInterval {
    case .daily:
      if let newDate = calendar.date(byAdding: .day, value: 1, to: startDate) {
        nextDate = newDate
      }
    case .weekly:
      if let newDate = calendar.date(byAdding: .weekOfYear, value: 1, to: startDate) {
        nextDate = newDate
      }
    case .biweekly:
      if let newDate = calendar.date(byAdding: .weekOfYear, value: 2, to: startDate) {
        nextDate = newDate
      }
    case .monthly:
      if let newDate = calendar.date(byAdding: .month, value: 1, to: startDate) {
        nextDate = coverEndOfMonthEdgeCase(date: newDate, dayOfEntry: dayOfEntry)
      }
    case .quarterly:
      if let newDate = calendar.date(byAdding: .month, value: 3, to: startDate) {
        nextDate = coverEndOfMonthEdgeCase(date: newDate, dayOfEntry: dayOfEntry)
      }
    case .semiannually:
      if let newDate = calendar.date(byAdding: .month, value: 6, to: startDate) {
        nextDate = coverEndOfMonthEdgeCase(date: newDate, dayOfEntry: dayOfEntry)
      }
    case .annually:
      if let newDate = calendar.date(byAdding: .year, value: 1, to: startDate) {
        nextDate = coverEndOfMonthEdgeCase(date: newDate, dayOfEntry: dayOfEntry)
      }
    }
    return nextDate
  }

  static func coverEndOfMonthEdgeCase(date: Date, dayOfEntry: Int) -> Date {
    if dayOfEntry >= 28 {
      return getAdjustedEndOfMonthDate(date: date, dayOfEntry: dayOfEntry)
    } else {
      return date
    }
  }

  static func getAdjustedEndOfMonthDate(date: Date, dayOfEntry: Int) -> Date {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
    let dayRange = calendar.range(of: .day, in: .month, for: date)!
    let lastDay = dayRange.upperBound
    var nextDateComponents = calendar.dateComponents([.year, .month, .hour, .minute], from: date)
    nextDateComponents.calendar = calendar
    nextDateComponents.day = min(dayOfEntry, lastDay)
    if !nextDateComponents.isValidDate {
      nextDateComponents.day = min(dayOfEntry, lastDay - 1)
    }
    if let adjustedDate = calendar.date(from: nextDateComponents) {
      return adjustedDate
    }
    return date
  }

  static func groupBookingsByInterval(entries: [BookingEntry]) -> [String: [BookingEntry]] {
    var groupedEntries: [String: [BookingEntry]] = [:]

    for entry in entries {
      if groupedEntries[entry.interval] == nil {
        groupedEntries[entry.interval] = []
      }
      groupedEntries[entry.interval]?.append(entry)
    }

    return groupedEntries
  }

  static func sortAndFilterBookings(
    bookings: [String: [BookingEntry]],
    sortBy: SortByEnum,
    sortOrder: SortOrderEnum,
    tagFilter: Set<String> = []
  ) -> [String: [BookingEntry]] {
    var sortedBookings: [String: [BookingEntry]] = [:]

    for (key, entries) in bookings {
      let sortedEntries = entries
        .filter { tagFilter.isEmpty || tagFilter.contains($0.tag?.uuid ?? "")}
        .sorted { (entry1, entry2) -> Bool in
        switch sortBy {
        case .name:
          if sortOrder == .forward {
            return entry1.name < entry2.name
          } else {
            return entry1.name > entry2.name
          }
        case .amount:
          if sortOrder == .reverse {
            return entry1.amount < entry2.amount
          } else {
            return entry1.amount > entry2.amount
          }
        }
      }
      sortedBookings[key] = sortedEntries
    }
    return sortedBookings
  }

  static func groupEntriesByMonthAndYearAndFilter(
    entries: [TimelineEntry],
    tagFilter: Set<String> = []
  ) -> [Date: [TimelineEntry]] {
    var groupedEntries: [Date: [TimelineEntry]] = [:]
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!

    for entry in entries {
      let components = calendar.dateComponents([.year, .month], from: entry.isDue)
      let monthYearDate = calendar.date(from: components)!

      if groupedEntries[monthYearDate] == nil {
        groupedEntries[monthYearDate] = []
      }
      if tagFilter.isEmpty || tagFilter.contains(entry.tag?.uuid ?? "") {
        groupedEntries[monthYearDate]?.append(entry)
      }
    }

    return groupedEntries
  }

  static func getListBackgroundView(bookingType: String, isActive: Bool, colorScheme: ColorScheme) -> some View {
    return HStack(spacing: 0) {
      Rectangle()
        .fill(Constants
          .getListBackgroundColor(
            for: BookingType(rawValue: bookingType)!,
            isActive: isActive
          ) ?? Constants.getBackground(colorScheme)
        )
        .frame(width: 10)
      Rectangle()
        .fill(Constants.getBackground(colorScheme))
    }
  }

  static func getDateOfOneYearInFuture() -> Date {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
    let nextYear = calendar.component(.year, from: .now) + 1
    let currentMonth = calendar.component(.month, from: .now)
    let currentDay = calendar.component(.day, from: .now) + 1
    var components = DateComponents()
    components.year = nextYear
    components.month = currentMonth
    components.day = currentDay
    components.hour = 23
    components.minute = 59

    return calendar.date(from: components)!
  }

  static func getSymbol(_ code: String) -> String? {
    let locale = NSLocale(localeIdentifier: code)
    return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
  }

  static func toggleDisplaySensitiveInfo(appStates: AppStates) {
    if appStates.biometricEnabled {
      appStates.authenticationActive = true
      BiometricHandler.shared.authenticateWithBiometrics { (success: Bool, error: Error?) in
        if success {
          DispatchQueue.main.async {
            withAnimation {
              appStates.blurSensitive.toggle()
              appStates.authenticationActive = false
            }
          }
        } else {
          if let error = error as? LAError {
            switch error.code {
            case .userCancel, .systemCancel:
              logger.error("Authentication code userCance flailed with error: \(error.localizedDescription)")
            case .userFallback:
              logger.error("Authentication code userFallback failed with error: \(error.localizedDescription)")
            default:
              logger.error("Authentication failed with error: \(error.localizedDescription)")
            }
          }
        }
      }
    } else {
      DispatchQueue.main.async {
        withAnimation {
          appStates.blurSensitive.toggle()
        }
      }
    }
  }
}
// swiftlint:enable type_body_length
// swiftlint:enable file_length
