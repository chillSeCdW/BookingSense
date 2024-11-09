// Created for BookingSense on 03.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct FilterDialog: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    NavigationView {
      List {
        Section("Tags") {
          ListOfTagsOptions()
        }
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

struct ListOfTagsOptions: View {
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
        appStates.toggleTimeStateFilter(option)
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
