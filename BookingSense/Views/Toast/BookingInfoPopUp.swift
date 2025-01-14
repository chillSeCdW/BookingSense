// Created for BookingSense on 12.07.24 by kenny
// Using Swift 5.0

import SwiftUI
import MijickPopups

struct BookingInfoPopUp: CenterPopup {
  let colorScheme: ColorScheme
  let message: String

  func configurePopup(popup: TopPopupConfig) -> TopPopupConfig {
    return popup
      .backgroundColor(Constants.getBackground(colorScheme))
  }

  // swiftlint:disable multiple_closures_with_trailing_closure
  var body: some View {
    VStack(spacing: 12) {
      HStack(spacing: 12) {
        Image(systemName: "info.circle.fill")
          .accessibilityIdentifier("InfoImage")
          .foregroundColor(Color.blue)
        VStack(alignment: .leading) {
          Text(String(localized: "Info"))
            .accessibilityIdentifier("InfoHeadline")
            .fontWeight(.semibold)
          Text(message)
            .accessibilityIdentifier("InfoMessage")
        }.fixedSize(horizontal: false, vertical: true)
      }
      Button(action: { Task { await dismissLastPopup() }}) {
        Text("Dismiss")
      }.accessibilityIdentifier("InfoDismiss")
    }
    .padding(.top, 20)
    .padding(.bottom, 16)
  }
  // swiftlint:enable multiple_closures_with_trailing_closure
}

#Preview {
  BookingInfoPopUp(colorScheme: ColorScheme.light, message: "")
}
