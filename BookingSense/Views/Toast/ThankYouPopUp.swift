// Created for BookingSense on 30.09.24 by kenny
// Using Swift 6.0

import SwiftUI
import MijickPopupView

struct ThankYouPopUp: TopPopup {
  let colorScheme: ColorScheme

  var message: String

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
        Image(systemName: "info.circle")
          .foregroundColor(Color.blue)
        VStack(alignment: .leading) {
          Text(String(localized: "Wuhoo!"))
            .fontWeight(.semibold)
          Text(message)
        }.fixedSize(horizontal: false, vertical: true)
      }
      Button(action: dismiss) {
        Text("Dismiss")
      }
    }
    .padding(.top, 20)
    .padding(.bottom, 16)
    .padding(.leading, 20)
    .padding(.trailing, 32)
  }
}

#Preview {
  ThankYouPopUp(colorScheme: ColorScheme.light, message: String(localized: "Thank you for your tip!"))
}
