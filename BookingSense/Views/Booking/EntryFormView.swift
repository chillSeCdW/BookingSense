//
//  EntryFormView.swift
//  BookingSense
//
//  Created by kenny on 25.04.24.
//

import SwiftUI
import TipKit

struct EntryFormView: View {
  var bookingEntry: BookingEntry?
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

  @FocusState var focusedName: Bool
  @FocusState var focusedAmount: Bool

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
    VStack {
      Picker("AmountPrefix", selection: $amountPrefix) {
        ForEach(AmountPrefix.allCases) { option in
          Text(LocalizedStringKey(option.description))
        }
      }
      .pickerStyle(.segmented)
      HStack {
        Picker("Interval", selection: $interval) {
          ForEach(Interval.allCases) { option in
            Text(String(describing: option.description))
          }
        }
        .accessibilityIdentifier("intervalPicker")
        .pickerStyle(.automatic)
        .labelsHidden()
        Spacer()
        TextField(
          text: $amount,
          prompt: Text("Amount")
        ) {
          Text("Amount")
        }
        .focused($focusedAmount)
        .multilineTextAlignment(.trailing)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .keyboardType(.decimalPad)
        .onAppear {
          if let bookingEntry {
            name = bookingEntry.name
            amountPrefix = bookingEntry.amountPrefix
            amount = formatter.string(from: NSDecimalNumber(decimal: bookingEntry.amount)) ?? ""
            interval = Interval(rawValue: bookingEntry.interval) ?? Interval.monthly
          }
        }
        Text(Constants.getSymbol(Locale.current.currency!.identifier) ?? "$")
          .accessibilityIdentifier("CurrencySymbol")
      }.alignmentGuide(.listRowSeparatorLeading) { _ in
        return 0
      }
    }
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

  EntryFormView(bookingEntry: entry,
                name: $name,
                amountPrefix: $amountPrefix,
                amount: $amount,
                interval: $interval)
}
