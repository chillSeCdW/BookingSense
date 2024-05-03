//
//  ToastMod.swift
//  BookingSense
//
//  Created by kenny on 17.04.24.
//

import Foundation
import SwiftUI

struct ToastMod: ViewModifier {

  @Binding var toast: Toast?
  @State private var workItem: DispatchWorkItem?

  func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay(
        ZStack {
          mainToastView()
            .offset(y: 40)
        }.animation(.spring(), value: toast)
      )
      .onChange(of: toast) {
        showToast()
      }
  }

  @ViewBuilder func mainToastView() -> some View {
    if let toast = toast {
      VStack {
        ToastView(
          type: toast.style,
          title: toast.title,
          message: toast.message
        ) {
          dismissToast()
        }
        Spacer()
      }
      .transition(.move(edge: .trailing))
    }
  }

  private func showToast() {
    guard let toast = toast else { return }

    UIImpactFeedbackGenerator(style: .light)
      .impactOccurred()

    if toast.duration > 0 {
      workItem?.cancel()
      let task = DispatchWorkItem {
        dismissToast()
      }
      workItem = task
      DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
    }
  }

  private func dismissToast() {
    withAnimation {
      toast = nil
    }
    workItem?.cancel()
    workItem = nil
  }
}
