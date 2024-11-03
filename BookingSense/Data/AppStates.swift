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
  var searchText: String = ""
  var searchTimelineText: String = ""
  var authenticationActive: Bool = false
}
