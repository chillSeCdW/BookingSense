//
//  ExpenseEntryView.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 10.04.24.
//

import SwiftUI
import SwiftData

struct ExpenseEntryView: View {
  @Bindable var expenseEntry: ExpenseEntry

  let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }()

  var body: some View {
    Form {
      TextField(text: $expenseEntry.name, prompt: Text("Name")) {
        Text("name")
      }
      HStack {
        Picker("Interval", selection: $expenseEntry.amountPrefix) {
            ForEach(AmountPrefix.allCases) { option in
              Text(String(describing: option.description))
            }
        }
        .pickerStyle(.wheel)
        .frame(maxWidth: 80, maxHeight: 100)
        TextField("test",
                  value: $expenseEntry.amount,
                  formatter: formatter)
          .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      Picker("Interval", selection: $expenseEntry.interval) {
          ForEach(Interval.allCases) { option in
            Text(String(describing: option.description))
          }
      }
      .pickerStyle(.wheel)
      .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 100)
    }
  }
}

#Preview {
  ExpenseEntryView(expenseEntry: ExpenseEntry(
    name: "testName",
    amount: 0,
    amountPrefix: .plus,
    interval: .weekly)
  )
    .modelContainer(for: ExpenseEntry.self, inMemory: true)
}
