// Created for BookingSense on 11.07.24 by kenny
// Using Swift 5.0

import SwiftUI
import MijickPopups

struct ResetHintsTopPopUp: CenterPopup {
  let colorScheme: ColorScheme

  func configurePopup(popup: TopPopupConfig) -> TopPopupConfig {
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
          Text(String(localized: "Info"))
            .fontWeight(.semibold)
          Text("Hints will be reset when restarting the App")
        }.fixedSize(horizontal: false, vertical: true)
      }
      Button(action: { Task { await dismissLastPopup() } }) {
        Text("Dismiss")
      }
    }
    .padding(.top, 20)
    .padding(.bottom, 16)
    .padding(.leading, 20)
    .padding(.trailing, 32)
  }
  // swiftlint:enable multiple_closures_with_trailing_closure
}

#Preview {
  ResetHintsTopPopUp(colorScheme: ColorScheme.light)
}
