//
//  AppStates.swift
//  BookingSense
//
//  Created by kenny on 24.04.24.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class AppStates {
  var isFilterDialogPresented: Bool = false

  var activeFilters: Set<TimelineEntryState> {
    didSet {
      let filtersArray = activeFilters.map { $0.rawValue }
      UserDefaults.standard.set(filtersArray, forKey: "activeFilters")
    }
  }
  var sortBy: SortByEnum = .name
  var sortOrder: SortOrderEnum = .reverse
  var searchText: String = ""
  var searchTimelineText: String = ""
  var authenticationActive: Bool = false

  init() {
    if let savedFilters = UserDefaults.standard.array(forKey: "activeFilters") as? [String] {
      self.activeFilters = Set(savedFilters.compactMap { TimelineEntryState(rawValue: $0) })
    } else {
      self.activeFilters = []
    }
  }

  func toggleFilter(_ filter: TimelineEntryState) {
    if activeFilters.contains(filter) {
      activeFilters.remove(filter)
    } else {
      activeFilters.insert(filter)
    }
  }
}
