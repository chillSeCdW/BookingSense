// Created for BookingSense on 09.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct BookingFilterDialog: View {
  @Environment(AppStates.self) var appStates

  @Query var tags: [Tag]

  var body: some View {
    NavigationView {
      List {
        if !tags.isEmpty {
          Section("Tags") {
            ListOfBookingTagsOptions()
          }
        }
        Section("States") {
          ListOfBookingStateOptions()
        }
        Section("Type") {
          ListOfBookingPrefixOptions()
        }
      }
      .navigationTitle("Select to show")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("Done") {
            appStates.isBookingFilterDialogPresented = false
          }
        }
      }
    }
  }
}

struct ListOfBookingTagsOptions: View {
  @Environment(AppStates.self) var appStates

  @Query var tags: [Tag]

  var body: some View {
    ForEach(tags, id: \.uuid) { option in
      HStack {
        Text(option.name)
        Spacer()
        if appStates.activeBookingTagFilters.contains(where: { $0 == option.uuid }) {
          Image(systemName: "checkmark")
            .foregroundColor(.blue)
        }
      }
      .contentShape(Rectangle())
      .onTapGesture {
        appStates.toggleBookingTagFilter(option)
      }
    }
  }
}

struct ListOfBookingStateOptions: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    ForEach(BookingEntryState.allCases, id: \.self) { option in
      HStack {
        Text(option.description)
        Spacer()
        if appStates.activeBookingStateFilters.contains(option) {
          Image(systemName: "checkmark")
            .foregroundColor(.blue)
        }
      }
      .contentShape(Rectangle())
      .onTapGesture {
        appStates.toggleBookingStateFilter(option)
      }
    }
  }
}

struct ListOfBookingPrefixOptions: View {
  @Environment(AppStates.self) var appStates

  var body: some View {
    ForEach(BookingType.allCases, id: \.self) { option in
      HStack {
        Text(option.description)
        Spacer()
        if appStates.activeBookingTypeFilters.contains(option) {
          Image(systemName: "checkmark")
            .foregroundColor(.blue)
        }
      }
      .contentShape(Rectangle())
      .onTapGesture {
        appStates.toggleBookingTypeFilter(option)
      }
    }
  }
}
