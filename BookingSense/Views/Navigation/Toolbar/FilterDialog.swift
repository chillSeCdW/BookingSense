// Created for BookingSense on 03.11.24 by kenny
// Using Swift 6.0

import SwiftUI

struct FilterDialog: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    NavigationView {
      List(TimelineEntryState.allCases) { option in
        HStack {
          Text(option.description)
          Spacer()
          if appStates.activeFilters.contains(option) {
            Image(systemName: "checkmark")
              .foregroundColor(.blue)
          }
        }
        .contentShape(Rectangle())
        .onTapGesture {
          appStates.toggleFilter(option)
        }
      }
      .navigationTitle("Select States to show")
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("Done") {
            appStates.isFilterDialogPresented = false
          }
        }
      }
    }
  }
}
