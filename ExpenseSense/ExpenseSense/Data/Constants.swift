//
//  Constants.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 27.03.24.
//

import SwiftUI

class Constants: Observable {
  var listBackgroundColors: [AmountPrefix: Color] = [AmountPrefix.plus: Color(.systemGreen),
                              AmountPrefix.minus: Color(.systemRed)]
  var darkGrey: UIColor = UIColor(white: 1, alpha: 0.15)
}
