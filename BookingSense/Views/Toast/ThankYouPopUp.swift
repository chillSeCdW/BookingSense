// Created for BookingSense on 30.09.24 by kenny
// Using Swift 6.0

import SwiftUI
import MijickPopups

struct ThankYouPopUp: CenterPopup {
  let colorScheme: ColorScheme

  var message: String

  func configurePopup(popup: CenterPopupConfig) -> CenterPopupConfig {
    return popup
      .backgroundColor(Constants.getBackground(colorScheme))
  }

  // swiftlint:disable multiple_closures_with_trailing_closure
  var body: some View {
    VStack(spacing: 12) {
      HStack(spacing: 12) {
        Image(systemName: "info.circle")
          .foregroundColor(Color.blue)
        VStack(alignment: .leading) {
          Text(String(localized: "Wuhoo!"))
            .fontWeight(.semibold)
          Text(message)
        }.fixedSize(horizontal: false, vertical: true)
      }
      Button(action: { Task { await dismissLastPopup() }}) {
        Text("Dismiss")
      }
    }
    .background(Constants.getBackground(colorScheme))
    .padding(.top, 20)
    .padding(.bottom, 16)
    .padding(.leading, 20)
    .padding(.trailing, 32)
  }
  // swiftlint:enable multiple_closures_with_trailing_closure
}

#Preview {
  ThankYouPopUp(colorScheme: ColorScheme.light, message: String(localized: "Thank you for your tip!"))
}
