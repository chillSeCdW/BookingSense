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
  var onCancelTapped: ((ToastStyle) -> Void)

  @State private var name: String = ""
  @State private var amountPrefix: AmountPrefix = .plus
  @State private var amount: String = ""
  @State private var interval: Interval = .monthly

  func save() {
    print(Locale.current.groupingSeparator!)
    print(Locale.current.decimalSeparator!)
    let parsedAmount = try? Decimal(amount, format: Decimal.FormatStyle(locale: Locale.current))
    if parsedAmount != nil {
      onCancelTapped(.success)
    }
    expenseEntry.name = name
    expenseEntry.amountPrefix = amountPrefix
    expenseEntry.amount = parsedAmount ?? Decimal()
    expenseEntry.interval = interval
  }

  var body: some View {
    Form {
      TextField(text: $name, prompt: Text("Name")) {
        Text("name")
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
        .keyboardType(.numbersAndPunctuation)
        .onAppear {
          name = expenseEntry.name
          amountPrefix = expenseEntry.amountPrefix
          amount = expenseEntry.amount.formatted()
          interval = expenseEntry.interval
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
      Button("save", systemImage: "arrow.up", action: save)
    }.onDisappear {
      save()
    }
  }

  func getSymbol(_ code: String) -> String? {
     let locale = NSLocale(localeIdentifier: code)
    return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
  }
}

#Preview {
  ExpenseEntryView(expenseEntry: ExpenseEntry(
    name: "testName",
    amount: Decimal(string: "15,35", locale: Locale(identifier: Locale.current.identifier)) ?? Decimal(),
    amountPrefix: .plus,
    interval: .weekly)
  ) { _ in

  }
    .modelContainer(for: ExpenseEntry.self, inMemory: true)
}
