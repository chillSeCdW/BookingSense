//
//  AppStates.swift
//  BookingSense
//
//  Created by kenny on 24.04.24.
//

import Foundation
import SwiftUI
import SwiftData

class AppStates: Observable, ObservableObject {
  @Published var isFilterDialogPresented: Bool = false

  @Published var activeTimeStateFilters: Set<TimelineEntryState> {
    didSet {
      let filtersArray = activeTimeStateFilters.map { $0.rawValue }
      UserDefaults.standard.set(filtersArray, forKey: "activeTimeEntryFilters")
    }
  }
  @Published var activeAmountPFilters: Set<AmountPrefix> {
    didSet {
      let filtersArray = activeAmountPFilters.map { $0.rawValue }
      UserDefaults.standard.set(filtersArray, forKey: "activeStateFilters")
    }
  }
  @Published var sortBy: SortByEnum {
    didSet {
      UserDefaults.standard.set(sortBy.rawValue, forKey: "BsortBy")
    }
  }
  @Published var sortOrder: SortOrderEnum {
    didSet {
      UserDefaults.standard.set(sortOrder.rawValue, forKey: "BSortOrder")
    }
  }
  @Published var searchText: String = ""
  @Published var searchTimelineText: String = ""
  @Published var authenticationActive: Bool = false
  @Published var blurSensitive: Bool {
    didSet {
      UserDefaults.standard.set(blurSensitive, forKey: "blurSensitive")
    }
  }
  @Published var biometricEnabled: Bool {
    didSet {
      UserDefaults.standard.set(biometricEnabled, forKey: "biometricEnabled")
    }
  }

  init() {
    if let savedFilters = UserDefaults.standard.array(forKey: "activeTimeEntryFilters") as? [String] {
      self.activeTimeStateFilters = Set(savedFilters.compactMap { TimelineEntryState(rawValue: $0) })
    } else {
      self.activeTimeStateFilters = [TimelineEntryState.open]
    }
    if let savedFilters = UserDefaults.standard.array(forKey: "activeStateFilters") as? [String] {
      self.activeAmountPFilters = Set(savedFilters.compactMap { AmountPrefix(rawValue: $0) })
    } else {
      self.activeAmountPFilters = [AmountPrefix.minus, AmountPrefix.plus, AmountPrefix.saving]
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
    self.blurSensitive = UserDefaults.standard.bool(forKey: "blurSensitive")
    self.biometricEnabled = UserDefaults.standard.bool(forKey: "biometricEnabled")
  }

  func toggleFilter(_ filter: TimelineEntryState) {
    if activeTimeStateFilters.contains(filter) {
      activeTimeStateFilters.remove(filter)
    } else {
      activeTimeStateFilters.insert(filter)
    }
  }

  func toggleFilter(_ filter: AmountPrefix) {
    if activeAmountPFilters.contains(filter) {
      activeAmountPFilters.remove(filter)
    } else {
      activeAmountPFilters.insert(filter)
    }
  }
}
