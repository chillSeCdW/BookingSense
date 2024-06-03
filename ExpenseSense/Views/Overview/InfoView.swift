// Created for BookingSense on 16.05.24 by kenny
// Using Swift 5.0

import SwiftUI

struct InfoView<F: FormatStyle>: View where F.FormatInput: Equatable, F.FormatOutput == String {
  let text: String
  let number: F.FormatInput
  let format: F

  var body: some View {
    VStack {
      HStack {
        Text(LocalizedStringKey(text))
        Spacer()
        Text(number, format: format)
      }
    }
  }
}

#Preview {
  VStack {
    InfoView(
      text: "Your total plus",
      number: Decimal(1000),
      format: .currency(code: Locale.current.currency!.identifier)
    )
    InfoView(
      text: "Your total plus",
      number: Decimal(1000),
      format: .number
    )
  }
}
