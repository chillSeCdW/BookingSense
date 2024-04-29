//
//  ViewInfo.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 24.04.24.
//

import Foundation
import SwiftData

@Observable
class ViewInfo {
    var sortParameter: SortParameter = .name

    var sortOrder: SortOrder = .reverse

    var searchText: String = ""

    var totalExpenseEntries: Int = 0

    func update(modelContext: ModelContext) {
      totalExpenseEntries = ExpenseEntry.totalExpenseEntries(modelContext: modelContext)
    }
}
