//
//  Toast.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 17.04.24.
//

import Foundation

struct Toast: Equatable {
  var style: ToastStyle
  var title: String
  var message: String
  var duration: Double = 2
  var width: Double = .infinity
}
