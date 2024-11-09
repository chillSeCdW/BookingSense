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
  @Published var isTimeFilterDialogPresented: Bool = false
  @Published var isBookingFilterDialogPresented: Bool = false

  // Filters for Bookings
  @Published var activeBookingStateFilters: Set<BookingEntryState> {
    didSet {
      let filtersArray = activeBookingStateFilters.map { $0.rawValue }
      UserDefaults.standard.set(filtersArray, forKey: "activeBookingStateFilters")
    }
  }
  @Published var activeBookingPrefixFilters: Set<AmountPrefix> {
    didSet {
      let filtersArray = activeBookingPrefixFilters.map { $0.rawValue }
      UserDefaults.standard.set(filtersArray, forKey: "activeBookingPrefixFilters")
    }
  }
  @Published var activeBookingTagFilters: Set<String> {
    didSet {
      let filtersArray = activeBookingTagFilters.map { $0 }
      UserDefaults.standard.set(filtersArray, forKey: "activeBookingTagFilters")
    }
  }
  // Filters for Timeentries
  @Published var activeTimeStateFilters: Set<TimelineEntryState> {
    didSet {
      let filtersArray = activeTimeStateFilters.map { $0.rawValue }
      UserDefaults.standard.set(filtersArray, forKey: "activeTimeStateFilters")
    }
  }
  @Published var activeTimePrefixFilters: Set<AmountPrefix> {
    didSet {
      let filtersArray = activeTimePrefixFilters.map { $0.rawValue }
      UserDefaults.standard.set(filtersArray, forKey: "activeTimePrefixFilters")
    }
  }
  @Published var activeTimeTagFilters: Set<String> {
    didSet {
      let filtersArray = activeTimeTagFilters.map { $0 }
      UserDefaults.standard.set(filtersArray, forKey: "activeTimeTagFilters")
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
    // Filters for Bookings
    if let savedFilters = UserDefaults.standard.array(forKey: "activeBookingStateFilters") as? [String] {
      self.activeBookingStateFilters = Set(savedFilters.compactMap { BookingEntryState(rawValue: $0) })
    } else {
      self.activeBookingStateFilters = [BookingEntryState.active]
    }
    if let savedFilters = UserDefaults.standard.array(forKey: "activeBookingPrefixFilters") as? [String] {
      self.activeBookingPrefixFilters = Set(savedFilters.compactMap { AmountPrefix(rawValue: $0) })
    } else {
      self.activeBookingPrefixFilters = [AmountPrefix.minus, AmountPrefix.plus, AmountPrefix.saving]
    }
    if let savedFilters = UserDefaults.standard.array(forKey: "activeBookingTagFilters") as? [String] {
      self.activeBookingTagFilters = Set(savedFilters.compactMap { $0 })
    } else {
      self.activeBookingTagFilters = []
    }
    // Filters for Timeentries
    if let savedFilters = UserDefaults.standard.array(forKey: "activeTimeStateFilters") as? [String] {
      self.activeTimeStateFilters = Set(savedFilters.compactMap { TimelineEntryState(rawValue: $0) })
    } else {
      self.activeTimeStateFilters = [TimelineEntryState.open]
    }
    if let savedFilters = UserDefaults.standard.array(forKey: "activeTimePrefixFilters") as? [String] {
      self.activeTimePrefixFilters = Set(savedFilters.compactMap { AmountPrefix(rawValue: $0) })
    } else {
      self.activeTimePrefixFilters = [AmountPrefix.minus, AmountPrefix.plus, AmountPrefix.saving]
    }
    if let savedFilters = UserDefaults.standard.array(forKey: "activeTimeTagFilters") as? [String] {
      self.activeTimeTagFilters = Set(savedFilters.compactMap { $0 })
    } else {
      self.activeTimeTagFilters = []
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

  func toggleBookingStateFilter(_ filter: BookingEntryState) {
    if activeBookingStateFilters.contains(filter) {
      activeBookingStateFilters.remove(filter)
    } else {
      activeBookingStateFilters.insert(filter)
    }
  }
  func toggleBookingPrefixFilter(_ filter: AmountPrefix) {
    if activeBookingPrefixFilters.contains(filter) {
      activeBookingPrefixFilters.remove(filter)
    } else {
      activeBookingPrefixFilters.insert(filter)
    }
  }
  func toggleBookingTagFilter(_ filter: Tag) {
    if activeBookingTagFilters.contains(filter.uuid) {
      activeBookingTagFilters.remove(filter.uuid)
    } else {
      activeBookingTagFilters.insert(filter.uuid)
    }
  }

  func toggleTimeStateFilter(_ filter: TimelineEntryState) {
    if activeTimeStateFilters.contains(filter) {
      activeTimeStateFilters.remove(filter)
    } else {
      activeTimeStateFilters.insert(filter)
    }
  }
  func toggleTimePrefixFilter(_ filter: AmountPrefix) {
    if activeTimePrefixFilters.contains(filter) {
      activeTimePrefixFilters.remove(filter)
    } else {
      activeTimePrefixFilters.insert(filter)
    }
  }
  func toggleTimeTagFilter(_ filter: Tag) {
    if activeTimeTagFilters.contains(filter.uuid) {
      activeTimeTagFilters.remove(filter.uuid)
    } else {
      activeTimeTagFilters.insert(filter.uuid)
    }
  }
}
