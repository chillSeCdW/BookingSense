// Created for BookingSense on 07.12.24 by kenny
// Using Swift 6.0
import Foundation

extension Decimal {
  public func generateFormattedNumber() -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.usesGroupingSeparator = false
    return formatter.string(from: NSDecimalNumber(decimal: self)) ?? ""
  }

  public func generateFormattedCurrency() -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.usesGroupingSeparator = false
    formatter.currencyCode = Locale.current.currency!.identifier
    return formatter.string(from: NSDecimalNumber(decimal: self)) ?? ""
  }

  public func generateFormattedPercent() -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.locale = Locale(identifier: "en_US")
    formatter.maximumFractionDigits = 2
    return formatter.string(from: NSDecimalNumber(decimal: self)) ?? ""
  }

}
