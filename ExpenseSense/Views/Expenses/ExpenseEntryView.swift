//
//  ExpenseEntryView.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 10.04.24.
//

import Foundation
import SwiftUI
import SwiftData

struct ExpenseEntryView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) var dismiss

  var expenseEntry: ExpenseEntry?
  var addToast: ((Toast) -> Void)

  @State private var name: String = ""
  @State private var amountPrefix: AmountPrefix = .plus
  @State private var amount: String = ""
  @State private var interval: Interval = .monthly

  private var isCreate: Bool {
    expenseEntry == nil ? true : false
  }

  var body: some View {
    NavigationStack {
      Form {
        ExpenseEntryForm(expenseEntry: expenseEntry,
                         name: $name,
                         amountPrefix: $amountPrefix,
                         amount: $amount,
                         interval: $interval
        )
      }.toolbar {
        ToolbarEntry(isCreate: isCreate, save: save, didValuesChange: didValuesChange)
      }
    }
  }

  func save() {
    let parsedAmount = try? Decimal(amount, format: Decimal.FormatStyle(locale: Locale.current))
    if checkIfAmountWasTransformed(amount, parsedDecimal: parsedAmount) {
      addToast(
        Constants.createToast(
          .info,
          message: String(localized: "\(parsedAmount?.formatted() ?? "0") transformedInfo")
        )
      )
    }

    if isCreate {
      modelContext.insert(ExpenseEntry(
        name: name,
        amount: parsedAmount ?? Decimal(),
        amountPrefix: amountPrefix,
        interval: interval
      ))
      dismiss()
    } else {
      expenseEntry!.name = name
      expenseEntry!.amountPrefix = amountPrefix
      expenseEntry!.amount = parsedAmount ?? Decimal()
      expenseEntry!.interval = interval.rawValue
    }
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
}

#Preview("Edit") {
  let entry = ExpenseEntry(
    name: "testName",
    amount: Decimal(string: "15,35", locale: Locale(identifier: Locale.current.identifier)) ?? Decimal(),
    amountPrefix: .plus,
    interval: .weekly)

  return ExpenseEntryView(expenseEntry: entry) { _ in
  }.environment(NavigationContext(selectedEntry: entry))
}

#Preview("Create") {
  ExpenseEntryView { _ in

  }.environment(NavigationContext())
}
