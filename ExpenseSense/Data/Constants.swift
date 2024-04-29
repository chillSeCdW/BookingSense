//
//  Constants.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 27.03.24.
//

import SwiftUI
import SwiftData

struct Constants {
  static var listBackgroundColors: [AmountPrefix: Color] = [
    AmountPrefix.plus: Color(UIColor(red: 0.2039, green: 0.7373, blue: 0.2039, alpha: 1.0)), // green
    AmountPrefix.minus: Color(UIColor(red: 0.7882, green: 0, blue: 0.0118, alpha: 1.0)) // red
  ]
  static var getBackground: (ColorScheme) -> Color = { scheme in
    scheme == .light ? .white : Color(uiColor: UIColor(white: 1, alpha: 0.15)) // darkGrey
  }

  static func createDescriptor(searchString: String, interval: Interval) -> FetchDescriptor<ExpenseEntry> {
    let predicate = ExpenseEntry.predicate(searchName: searchString, interval: interval)
    let descriptor = FetchDescriptor<ExpenseEntry>(
      predicate: predicate,
      sortBy: [SortDescriptor(\.name, order: .forward)]
    )
    return descriptor
  }

  static func getSymbol(_ code: String) -> String? {
     let locale = NSLocale(localeIdentifier: code)
    return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
  }

  static func createToast(_ toastType: ToastStyle, message: String) -> Toast {
    switch toastType {
    case .info:
      return Toast(style: .info, title: String(localized: "Info"), message: message, duration: 10, width: 160)
    default:
      return Toast(style: .error, title: String(localized: "Error"), message: message, duration: 10, width: 160)
    }
  }
}
