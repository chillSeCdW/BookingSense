//
//  ToastView.swift
//  BookingSense
//
//  Created by kenny on 17.04.24.
//

import SwiftUI

struct ToastView: View {
  @Environment(\.colorScheme) var colorScheme

  var type: ToastStyle
  var title: String
  var message: String
  var onCancelTapped: (() -> Void)

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .top) {
        Image(systemName: type.iconName)
          .foregroundColor(type.color)
        VStack(alignment: .leading) {
          Text(title)
            .font(.system(size: 14, weight: .semibold))
          Text(message)
            .font(.system(size: 12))
        }
        Spacer(minLength: 10)
        Button {
          onCancelTapped()
        } label: {
          Image(systemName: "xmark")
            .foregroundColor(colorScheme == .dark ? .white : .black)
        }
      }
      .padding()
    }
    .background(Constants.getBackground(colorScheme))
    .overlay(
      Rectangle()
        .fill(type.color)
        .frame(width: UIScreen.main.bounds.width, height: 10)
        .clipped(),
      alignment: .topLeading
    )
    .frame(minWidth: 0, maxWidth: .infinity)
    .clipShape(RoundedRectangle(cornerSize: CGSize.init(width: 5, height: 5)))
    .padding(.horizontal, 16)
  }
}

#Preview {
  VStack {
    ToastView(
      type: .error,
      title: String(localized: "Error"),
      message: "Some Example Text. Some Example Text.") {}
    ToastView(
      type: .info,
      title: String(localized: "Info"),
      message: "Some Example Text. Some Example Text. Some Example Text.") {}
    ToastView(
      type: .success,
      title: String(localized: "Success"),
      message: "Some Example Text. Some Example Text. Some Example Text.") {}
  }
}

extension View {
  func toastView(toast: Binding<Toast?>) -> some View {
    self.modifier(ToastMod(toast: toast))
  }
}
