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
  var sortBy: SortByEnum {
    didSet {
      UserDefaults.standard.set(sortBy.rawValue, forKey: "BsortBy")
    }
  }
  var sortOrder: SortOrderEnum {
    didSet {
      UserDefaults.standard.set(sortOrder.rawValue, forKey: "BSortOrder")
    }
  }
  var searchText: String = ""
  var searchTimelineText: String = ""
  var authenticationActive: Bool = false

  init() {
    if let savedFilters = UserDefaults.standard.array(forKey: "activeFilters") as? [String] {
      self.activeFilters = Set(savedFilters.compactMap { TimelineEntryState(rawValue: $0) })
    } else {
      self.activeFilters = [TimelineEntryState.open]
    }
    if let sortByEnum = UserDefaults.standard.string(forKey: "BsortBy") {
      self.sortBy = SortByEnum(rawValue: sortByEnum) ?? .name
    } else {
      self.sortBy = .name
    }
    if let sortOrderEnum = UserDefaults.standard.string(forKey: "BSortOrder") {
      self.sortOrder = SortOrderEnum(rawValue: sortOrderEnum) ?? .reverse
    } else {
      self.sortOrder = .reverse
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
