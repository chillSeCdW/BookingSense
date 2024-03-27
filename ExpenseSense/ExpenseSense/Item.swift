//
//  Item.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 18.03.24.
//

import Foundation
import SwiftData

@Model
final class Item {
  var timestamp: Date
    
  init(timestamp: Date) {
      self.timestamp = timestamp
  }
}
