//
//  ToolbarEntryList.swift
//  BookingSense
//
//  Created by kenny on 25.04.24.
//

import SwiftUI
import LocalAuthentication
import OSLog

struct ToolbarEntryList: ToolbarContent {
  private let logger = Logger(subsystem: "BookingSense", category: "ToolbarEntryList")

  @Environment(\.editMode) private var editMode
  @Environment(AppStates.self) var appStates

  @Binding var showingConfirmation: Bool

  var addEntry: () -> Void

  var body: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button(action: {
        Constants.toggleDisplaySensitiveInfo(
          appStates: appStates)
      }, label: {
        Image(systemName: appStates.blurSensitive ? "eye.slash" : "eye")
      })
      .contentTransition(.symbolEffect(.replace.downUp.byLayer))
    }
    ToolbarItem(placement: .navigationBarLeading) {
      SortButtonView()
    }
    ToolbarItem(placement: .navigationBarLeading) {
      Button(action: { appStates.isBookingFilterDialogPresented.toggle()},
             label: { Image(systemName: "line.horizontal.3.decrease.circle") }
      )
    }
    if editMode?.wrappedValue.isEditing == true {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Delete all", systemImage: "trash", role: .destructive, action: showPopup)
          .tint(.red)
      }
    }
    ToolbarItem(placement: .navigationBarTrailing) {
      Button("Plus", systemImage: "plus", action: addEntry)
        .popoverTip(ToolbarAddTip())
    }
    ToolbarItem(placement: .navigationBarTrailing) {
      EditButton()
    }
  }

  func showPopup() {
    withAnimation {
      showingConfirmation = true
    }
  }
}
