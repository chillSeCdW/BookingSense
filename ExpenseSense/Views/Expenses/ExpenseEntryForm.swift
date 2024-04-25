//
//  ExpenseEntryForm.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 25.04.24.
//

import SwiftUI

struct ExpenseEntryForm: View {
  var expenseEntry: ExpenseEntry?

  @Binding var name: String
  @Binding var amountPrefix: AmountPrefix
  @Binding var amount: String
  @Binding var interval: Interval

  var body: some View {
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
        if let expenseEntry {
          name = expenseEntry.name
          amountPrefix = expenseEntry.amountPrefix
          amount = expenseEntry.amount.formatted()
          interval = Interval(rawValue: expenseEntry.interval) ?? Interval.monthly
        }
      }
      Text(Constants.getSymbol(Locale.current.currency!.identifier) ?? "$")
    }.alignmentGuide(.listRowSeparatorLeading) { _ in
        return 0
    }
    Picker("Interval", selection: $interval) {
      ForEach(Interval.allCases) { option in
        Text(String(describing: option.description))
      }
    }
    .pickerStyle(.menu)
  }
}

#Preview {
  let entry = ExpenseEntry(
    name: "testName",
    amount: Decimal(string: "15,35", locale: Locale(identifier: Locale.current.identifier)) ?? Decimal(),
    amountPrefix: .plus,
    interval: .weekly)

  @State var name = entry.name
  @State var amount = entry.amount.formatted()
  @State var amountPrefix: AmountPrefix = entry.amountPrefix
  @State var interval: Interval = Interval(rawValue: entry.interval) ?? Interval.monthly

  return ExpenseEntryForm(expenseEntry: entry,
                          name: $name,
                          amountPrefix: $amountPrefix,
                          amount: $amount,
                          interval: $interval)
  .environment(NavigationContext(selectedEntry: entry))
}
