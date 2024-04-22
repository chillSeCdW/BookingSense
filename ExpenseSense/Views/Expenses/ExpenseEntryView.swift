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
  @Bindable var expenseEntry: ExpenseEntry
  var showToast: ((ToastStyle, String) -> Void)

  @State private var name: String = ""
  @State private var amountPrefix: AmountPrefix = .plus
  @State private var amount: String = ""
  @State private var interval: Interval = .monthly
  @State private var oldName: String = ""
  @State private var oldAmountPrefix: AmountPrefix = .plus
  @State private var oldAmount: String = ""
  @State private var oldInterval: Interval = .monthly

  var body: some View {
    Form {
      TextField(text: $name, prompt: Text("Name")) {
        Text("Name")
      }
      HStack {
        Picker("Interval", selection: $amountPrefix) {
            ForEach(AmountPrefix.allCases) { option in
              Text(String(describing: option.description))
            }
        }
        .pickerStyle(.wheel)
        .frame(maxWidth: 80, maxHeight: 100)
        TextField(
          text: $amount,
          prompt: Text("Amount")
        ) {
          Text("Amount")
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .keyboardType(.decimalPad)
        .onAppear {
          name = expenseEntry.name
          amountPrefix = expenseEntry.amountPrefix
          amount = expenseEntry.amount.formatted()
          interval = expenseEntry.interval
          oldName = name
          oldAmountPrefix = amountPrefix
          oldAmount = amount
          oldInterval = interval
        }
        Text(getSymbol(Locale.current.currency!.identifier) ?? "$")
      }
      Picker("Interval", selection: $interval) {
          ForEach(Interval.allCases) { option in
            Text(String(describing: option.description))
          }
      }
      .pickerStyle(.wheel)
      .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 100)
      if didValuesChange() {
        Button("revertButton", systemImage: "arrow.circlepath", action: revert)
      }
    }.onDisappear {
      save()
    }
  }

  func save() {
    let parsedAmount = try? Decimal(amount, format: Decimal.FormatStyle(locale: Locale.current))
    if checkIfAmountWasTransformed(amount, parsedDecimal: parsedAmount) {
      showToast(.info, String(localized: "\(parsedAmount?.formatted() ?? "0") transformedInfo")
      )
    } else {
      showToast(.success, String(localized: "saved Data"))
    }
    expenseEntry.name = name
    expenseEntry.amountPrefix = amountPrefix
    expenseEntry.amount = parsedAmount ?? Decimal()
    expenseEntry.interval = interval
  }

  func revert() {
    name = oldName
    amountPrefix = oldAmountPrefix
    amount = oldAmount
    interval = oldInterval
  }

  func getSymbol(_ code: String) -> String? {
     let locale = NSLocale(localeIdentifier: code)
    return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
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
    if name != oldName ||
        amount != oldAmount ||
        amountPrefix != oldAmountPrefix ||
        interval != oldInterval {
      return true
    }

    return false
  }
}

#Preview {
  ExpenseEntryView(expenseEntry: ExpenseEntry(
    name: "testName",
    amount: Decimal(string: "15,35", locale: Locale(identifier: Locale.current.identifier)) ?? Decimal(),
    amountPrefix: .plus,
    interval: .weekly)
  ) { _, _ in

  }
    .modelContainer(for: ExpenseEntry.self, inMemory: true)
}
