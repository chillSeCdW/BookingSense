// Created for BookingSense on 06.05.24 by kenny
// Using Swift 5.0

import Foundation

class TestHelper {

  let aClass: AnyClass

  init(_ aClass: AnyClass) {
    self.aClass = aClass
  }

  func localized(_ key: String) -> String {
    let uiTestBundle = Bundle(for: aClass)
    return NSLocalizedString(key, bundle: uiTestBundle, comment: "")
  }

  func generateFormattedCurrencyFor(_ localeId: String, number: Decimal) -> String {
    number.formatted(.currency(code: localeId))
  }

  func generateFormattedStringFromCurrentLocaleFor(_ number: Decimal) -> String {
    generateFormattedCurrencyFor(Locale.current.currency!.identifier, number: number)
  }
}
