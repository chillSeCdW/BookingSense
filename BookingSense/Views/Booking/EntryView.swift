//
//  EntryView.swift
//  BookingSense
//
//  Created by kenny on 10.04.24.
//

import Foundation
import SwiftUI
import SwiftData

struct EntryView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) var dismiss

  var expenseEntry: BookingEntry?

  @State private var name: String = ""
  @State private var amountPrefix: AmountPrefix = .minus
  @State private var amount: String = ""
  @State private var interval: Interval = .monthly

  private var isCreate: Bool {
    expenseEntry == nil ? true : false
  }

  var body: some View {
    Form {
      EntryFormView(expenseEntry: expenseEntry,
                    name: $name,
                    amountPrefix: $amountPrefix,
                    amount: $amount,
                    interval: $interval
      )
    }.navigationTitle(isCreate ? "Create entry" : "Edit entry")
      .toolbar {
        ToolbarEntry(isCreate: isCreate, save: save, didValuesChange: didValuesChange)
      }
  }

  func save() {
    let sanitizedAmount = stripString(amount)

    let parsedAmount = try? Decimal(sanitizedAmount, format: Decimal.FormatStyle(locale: Locale.current))
    if checkIfAmountWasTransformed(sanitizedAmount, parsedDecimal: parsedAmount) {
      BookingInfoPopUp(colorScheme: colorScheme, parsedAmount: parsedAmount)
        .showAndStack()
        .dismissAfter(10)
    }

    if isCreate {
      modelContext.insert(BookingEntry(
        name: name,
        tags: ["default"],
        amount: parsedAmount ?? Decimal(),
        amountPrefix: amountPrefix,
        interval: interval
      ))
    } else {
      expenseEntry!.name = name
      expenseEntry!.amountPrefix = amountPrefix
      expenseEntry!.amount = parsedAmount ?? Decimal()
      expenseEntry!.interval = interval.rawValue
    }
    dismiss()
  }

  func checkIfAmountWasTransformed(_ amountStr: String, parsedDecimal: Decimal?) -> Bool {
    if parsedDecimal != nil {
      if (0...2).contains(amountStr.components(separatedBy: Locale.current.decimalSeparator!).count) {
        return false
      }
      if amountStr.elementsEqual(parsedDecimal!.formatted()) {
        return false
      }
      return true
    }
    return true
  }

  func didValuesChange() -> Bool {
    if let expenseEntry {
      if name != expenseEntry.name ||
          amount != expenseEntry.amount.formatted() ||
          amountPrefix != expenseEntry.amountPrefix ||
          interval != Interval(rawValue: expenseEntry.interval) ?? Interval.monthly {
        return true
      }
    }

    return false
  }

  func stripString(_ input: String) -> String {
    let pattern = "[^0-9,\\.]"
    if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
      let range = NSRange(location: 0, length: input.utf16.count)
      let modifiedString = regex.stringByReplacingMatches(in: input, options: [], range: range, withTemplate: "")
      return modifiedString
    }
    return "0"
  }
}

#Preview("Edit") {
  let entry = BookingEntry(
    name: "testName",
    tags: ["default"],
    amount: Decimal(string: "15,35", locale: Locale(identifier: Locale.current.identifier)) ?? Decimal(),
    amountPrefix: .plus,
    interval: .weekly)

  return EntryView(expenseEntry: entry)
}

#Preview("Create") {
  EntryView()
}
