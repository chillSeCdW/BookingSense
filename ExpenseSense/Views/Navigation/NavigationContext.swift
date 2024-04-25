//
//  NavigationContext.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 24.04.24.
//

import Foundation

@Observable
class NavigationContext {
  var selectedEntry: ExpenseEntry?

  init(selectedEntry: ExpenseEntry? = nil) {
      self.selectedEntry = selectedEntry
  }
}
