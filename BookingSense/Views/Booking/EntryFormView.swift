//
//  EntryFormView.swift
//  BookingSense
//
//  Created by kenny on 25.04.24.
//

import SwiftUI
import TipKit

struct EntryFormView: View {
  var expenseEntry: BookingEntry?
  var formatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.usesGroupingSeparator = false
    return formatter
  }

  @Binding var name: String
  @Binding var amountPrefix: AmountPrefix
  @Binding var amount: String
  @Binding var interval: Interval

  @FocusState private var focusedName: Bool
  @FocusState private var focusedAmount: Bool

  var body: some View {
    TextField(text: $name, prompt: Text("Name")) {
      Text("Name")
    }.toolbar {
      ToolbarItemGroup(placement: .keyboard) {
        Spacer()
        Button("Done") {
          focusedName = false
          focusedAmount = false
        }
      }
    }
    .focused($focusedName)
    .onSubmit {
      focusedAmount = true
    }
    TipView(PrefixBookingTip())
    HStack {
      Picker("AmountPrefix", selection: $amountPrefix) {
        ForEach(AmountPrefix.allCases) { option in
          Label(option.description, systemImage: option.description)
            .labelStyle(.iconOnly)
        }
      }
      .pickerStyle(.wheel)
      .frame(maxWidth: 80, maxHeight: 100)
      TextField(
        text: $amount,
        prompt: Text("Amount")
      ) {
        Text("Amount")
      }.focused($focusedAmount)
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .keyboardType(.decimalPad)
      .onAppear {
        if let expenseEntry {
          name = expenseEntry.name
          amountPrefix = expenseEntry.amountPrefix
          amount = formatter.string(from: NSDecimalNumber(decimal: expenseEntry.amount)) ?? ""
          interval = Interval(rawValue: expenseEntry.interval) ?? Interval.monthly
        }
        focusedName = true
      }
      Text(Constants.getSymbol(Locale.current.currency!.identifier) ?? "$")
        .accessibilityIdentifier("CurrencySymbol")
    }.alignmentGuide(.listRowSeparatorLeading) { _ in
        return 0
    }
    Picker("Interval", selection: $interval) {
      ForEach(Interval.allCases) { option in
        Text(String(describing: option.description))
      }
    }.accessibilityIdentifier("intervalPicker")
    .pickerStyle(.menu)
  }
}

#Preview {
  @Previewable @State var name: String = "testName"
  @Previewable @State var amount: String = "15,35"
  @Previewable @State var amountPrefix: AmountPrefix = .plus
  @Previewable @State var interval: Interval = .weekly

  let entry = BookingEntry(
    name: "testName",
    tags: ["default"],
    amount: Decimal(string: "15,35", locale: Locale(identifier: Locale.current.identifier)) ?? Decimal(),
    amountPrefix: .plus,
    interval: .weekly)

  EntryFormView(expenseEntry: entry,
                          name: $name,
                          amountPrefix: $amountPrefix,
                          amount: $amount,
                          interval: $interval)
}
