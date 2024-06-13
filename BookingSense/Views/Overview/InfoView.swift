// Created for BookingSense on 16.05.24 by kenny
// Using Swift 5.0

import SwiftUI
import TipKit

struct InfoView<F: FormatStyle>: View where F.FormatInput == Decimal, F.FormatOutput == String {
  let text: String
  let number: F.FormatInput
  let format: F
  var infoHeadline: String?
  var infoText: String?
  @State private var showInfo = false

  var body: some View {
    VStack {
      HStack {
        if infoHeadline != nil {
          InfoBoxButtonView(headline: infoHeadline!, infoText: infoText)
        }
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
      format: .currency(code: Locale.current.currency!.identifier),
      infoHeadline: "How it's calculated"
    )
    InfoView(
      text: "Your total plus",
      number: Decimal(1000),
      format: .number
    )
    InfoView(
      text: "Your total plus",
      number: Decimal(0),
      format: .number
    )
  }
}
