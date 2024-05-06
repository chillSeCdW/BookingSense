// Created for BookingSense on 06.05.24 by kenny
// Using Swift 5.0

import Foundation

class TestHelper {

  static func generateFormattedCurrencyFor(_ localeId: String, number: Decimal) -> String {
    number.formatted(.currency(code: localeId))
  }

  static func generateFormattedStringFromCurrentLocaleFor(_ number: Decimal) -> String {
    generateFormattedCurrencyFor(Locale.current.currency!.identifier, number: number)
  }
}
