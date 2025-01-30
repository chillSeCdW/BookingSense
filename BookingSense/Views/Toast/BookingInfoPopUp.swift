// Created for BookingSense on 12.07.24 by kenny
// Using Swift 5.0

import SwiftUI
import MijickPopupView

struct BookingInfoPopUp: TopPopup {
  let colorScheme: ColorScheme
  let parsedAmount: Decimal?

  func configurePopup(popup: TopPopupConfig) -> TopPopupConfig {
    let scene = (UIApplication.shared.connectedScenes.first as? UIWindowScene)
    let safeAreaPaddingTop = scene?.windows.first?.safeAreaInsets.top

    return popup
      .backgroundColour(StyleHelper.getBackground(colorScheme))
      .topPadding(safeAreaPaddingTop ?? 55)
      .horizontalPadding(16)
  }

  func createContent() -> some View {
    VStack(spacing: 12) {
      HStack(spacing: 12) {
        Image(systemName: "info.circle.fill")
          .accessibilityIdentifier("InfoImage")
          .foregroundColor(Color.blue)
        VStack(alignment: .leading) {
          Text(String(localized: "Info"))
            .accessibilityIdentifier("InfoHeadline")
            .fontWeight(.semibold)
          Text(String(localized: "\(parsedAmount?.formatted() ?? "0") transformedInfo"))
            .accessibilityIdentifier("InfoMessage")
        }.fixedSize(horizontal: false, vertical: true)
      }
      Button(action: dismiss) {
        Text("Dismiss")
      }.accessibilityIdentifier("InfoDismiss")
    }
    .padding(.top, 20)
    .padding(.bottom, 16)
  }
}

#Preview {
  BookingInfoPopUp(colorScheme: ColorScheme.light, parsedAmount: Decimal())
}
