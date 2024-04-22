//
//  Constants.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 27.03.24.
//

import SwiftUI

class Constants: Observable {
  var listBackgroundColors: [AmountPrefix: Color] = [
    AmountPrefix.plus: Color(UIColor(red: 0.2039, green: 0.7373, blue: 0.2039, alpha: 1.0)), // green
    AmountPrefix.minus: Color(UIColor(red: 0.7882, green: 0, blue: 0.0118, alpha: 1.0)) // red
  ]
  var getBackground: (ColorScheme) -> Color = { scheme in
    scheme == .light ? .white : Color(uiColor: UIColor(white: 1, alpha: 0.15)) // darkGrey
  }
}
