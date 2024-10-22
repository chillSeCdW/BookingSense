//
//  SortButtonView.swift
//  BookingSense
//
//  Created by kenny on 24.04.24.
//

import SwiftUI

struct SortButtonView: View {
    @AppStorage("sortParameter") var sortParameter: SortParameter = .name
    @AppStorage("sortOrder") var sortOrder: SortOrderParameter = .reverse

    var body: some View {
        Menu {
            Picker("Sort order", selection: $sortOrder) {
                ForEach(SortOrderParameter.allCases) { order in
                    Text(order.name)
                }
            }
            Picker("Sort by", selection: $sortParameter) {
                ForEach(SortParameter.allCases) { parameter in
                    Text(parameter.name)
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
        .pickerStyle(.inline)
    }
}

enum SortParameter: String, CaseIterable, Identifiable {
    case name, amount
    var id: Self { self }
  var name: String {
    let key = "sort_parameter.\(rawValue.lowercased())"
    return NSLocalizedString(key, comment: "")
  }
}

enum SortOrderParameter: String, CaseIterable, Identifiable {
    case forward, reverse
    var id: Self { self }
    var name: String {
      let key = "sort_order.\(rawValue.lowercased())"
      return NSLocalizedString(key, comment: "")
    }
}

#Preview {
    SortButtonView()
        .environment(AppStates())
}
