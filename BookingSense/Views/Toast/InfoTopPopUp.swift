// Created for BookingSense on 11.07.24 by kenny
// Using Swift 5.0

import SwiftUI
import MijickPopupView

struct InfoTopPopUp: TopPopup {
  let colorScheme: ColorScheme

  func configurePopup(popup: TopPopupConfig) -> TopPopupConfig {
    let scene = (UIApplication.shared.connectedScenes.first as? UIWindowScene)
    let safeAreaPaddingTop = scene?.windows.first?.safeAreaInsets.top

    return popup
      .backgroundColour(Constants.getBackground(colorScheme))
      .topPadding(safeAreaPaddingTop ?? 55)
      .horizontalPadding(16)
  }

  func createContent() -> some View {
    VStack(spacing: 12) {
      createTopView()
      createDismissButton()
    }
    .padding(.top, 20)
    .padding(.bottom, 16)
    .padding(.leading, 20)
    .padding(.trailing, 32)
  }
}

private extension InfoTopPopUp {
  func createTopView() -> some View {
    HStack(spacing: 0) {
      Image(systemName: "info.circle")
      Spacer()
      Text("Hints will be reset when restarting the App")
        .fixedSize(horizontal: false, vertical: true)
    }
  }
  func createDismissButton() -> some View {
    HStack {
      Button(action: dismiss) {
        Text("Dismiss")
      }
    }
  }
}

#Preview {
  InfoTopPopUp(colorScheme: ColorScheme.light)
}
