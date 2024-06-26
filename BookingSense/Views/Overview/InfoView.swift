// Created for BookingSense on 16.05.24 by kenny
// Using Swift 5.0

import SwiftUI

struct InfoView<F: FormatStyle>: View where F.FormatInput == Decimal, F.FormatOutput == String {
  @AppStorage("blurSensitive") var blurSensitive = false

  let text: LocalizedStringKey
  let number: F.FormatInput
  let format: F
  var infoHeadline: LocalizedStringKey?
  var infoText: LocalizedStringKey?
  var showApprox = false

  var body: some View {
    VStack {
      HStack {
        if infoHeadline != nil {
          InfoBoxButtonView(headline: infoHeadline!, infoText: infoText)
        }
        Text(text)
        Spacer()
        if showApprox {
          Text("~")
        }
        Text(number, format: format)
          .blur(radius: blurSensitive ? 5.0 : 0)
      }
    }
  }
}

#Preview {
  VStack {
    InfoView(
      text: "All income as \(Interval.annually.description)",
      number: Decimal(1000),
      format: .currency(code: Locale.current.currency!.identifier),
      infoHeadline: "How it's calculated"
    )
    InfoView(
      text: "All income as \(Interval.annually.description)",
      number: Decimal(1000),
      format: .number
    )
    InfoView(
      text: "All income as \(Interval.annually.description)",
      number: Decimal(0),
      format: .number
    )
  }
}
