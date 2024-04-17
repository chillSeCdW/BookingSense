//
//  ToastStyle.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 17.04.24.
//

import Foundation
import SwiftUI

enum ToastStyle {
  case error
  case info
  case success

  var color: Color {
    switch self {
    case .error: return Color.red
    case .info: return Color.blue
    case .success: return Color.green
    }
}

var iconName: String {
  switch self {
    case .error: return "xmark.circle.fill"
    case .info: return "info.circle.fill"
    case .success: return "checkmark.circle.fill"
    }
  }
}
