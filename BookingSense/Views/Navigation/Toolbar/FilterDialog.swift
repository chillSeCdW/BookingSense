// Created for BookingSense on 03.11.24 by kenny
// Using Swift 6.0

import SwiftUI

struct FilterDialog: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    NavigationView {
      List {
        Section("States") {
          ListOfTimelineStateOptions()
        }
        Section("Type") {
          ListOfAmountPrefixOptions()
        }
      }
      .navigationTitle("Select to show")
      .navigationBarTitleDisplayMode(.inline)
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

struct ListOfTimelineStateOptions: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    ForEach(TimelineEntryState.allCases, id: \.self) { option in
      HStack {
        Text(option.description)
        Spacer()
        if appStates.activeTimeStateFilters.contains(option) {
          Image(systemName: "checkmark")
            .foregroundColor(.blue)
        }
      }
      .contentShape(Rectangle())
      .onTapGesture {
        appStates.toggleFilter(option)
      }
    }
  }
}

struct ListOfAmountPrefixOptions: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    ForEach(AmountPrefix.allCases, id: \.self) { option in
      HStack {
        Text(option.description)
        Spacer()
        if appStates.activeAmountPFilters.contains(option) {
          Image(systemName: "checkmark")
            .foregroundColor(.blue)
        }
      }
      .contentShape(Rectangle())
      .onTapGesture {
        appStates.toggleFilter(option)
      }
    }
  }
}
