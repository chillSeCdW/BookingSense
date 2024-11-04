//
//  SortButtonView.swift
//  BookingSense
//
//  Created by kenny on 24.04.24.
//

import SwiftUI

struct SortButtonView: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    @Bindable var appStates = appStates

    Menu {
      Picker("Sort order", selection: $appStates.sortOrder) {
        ForEach(SortOrderEnum.allCases) { order in
          Text(order.name)
        }
      }
      Picker("Sort by", selection: $appStates.sortBy) {
        ForEach(SortByEnum.allCases) { parameter in
          Text(parameter.name)
        }
      }
    } label: {
      Label("Sort", systemImage: "arrow.up.arrow.down")
    }
    .pickerStyle(.inline)
  }
}


#Preview {
  SortButtonView()
    .environment(AppStates())
}
