//
//  ViewInfo.swift
//  BookingSense
//
//  Created by kenny on 24.04.24.
//

import Foundation
import SwiftData

@Observable
class SortingInfo {
    var sortParameter: SortParameter = .name

    var sortOrder: SortOrder = .reverse

    var searchText: String = ""
}
