// Created for BookingSense on 03.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TimeFilterDialog: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    NavigationView {
      List {
        Section("Tags") {
          ListOfTimeTagsOptions()
        }
        Section("States") {
          ListOfTimeStateOptions()
        }
        Section("Type") {
          ListOfTimePrefixOptions()
        }
      }
      .navigationTitle("Select to show")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("Done") {
            appStates.isTimeFilterDialogPresented = false
          }
        }
      }
    }
  }
}

struct ListOfTimeTagsOptions: View {
  @Environment(AppStates.self) var appStates

  @Query var tags: [Tag]

  var body: some View {
    ForEach(tags, id: \.uuid) { option in
      HStack {
        Text(option.name)
        Spacer()
        if appStates.activeTimeTagFilters.contains(where: { $0 == option.uuid }) {
          Image(systemName: "checkmark")
            .foregroundColor(.blue)
        }
      }
      .contentShape(Rectangle())
      .onTapGesture {
        appStates.toggleTimeTagFilter(option)
      }
    }
  }
}

struct ListOfTimeStateOptions: View {
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
        appStates.toggleTimeStateFilter(option)
      }
    }
  }
}

struct ListOfTimePrefixOptions: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    ForEach(AmountPrefix.allCases, id: \.self) { option in
      HStack {
        Text(option.description)
        Spacer()
        if appStates.activeTimePrefixFilters.contains(option) {
          Image(systemName: "checkmark")
            .foregroundColor(.blue)
        }
      }
      .contentShape(Rectangle())
      .onTapGesture {
        appStates.toggleTimePrefixFilter(option)
      }
    }
  }
}
