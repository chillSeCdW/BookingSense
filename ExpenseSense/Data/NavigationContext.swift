//
//  NavigationContext.swift
//  BookingSense
//
//  Created by kenny on 24.04.24.
//

import Foundation

@Observable
class NavigationContext {
  var toast: Toast?

  init(toast: Toast? = nil) {
    self.toast = toast
  }

  func addToast(createdToast: Toast) {
    toast = createdToast
  }
}
