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
  @AppStorage("blurSensitive") var blurSensitive = false
  @AppStorage("biometricEnabled") var biometricEnabled = false

  @Binding var showingConfirmation: Bool

  var addEntry: () -> Void

  var body: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button(action: toggleDisplaySensitiveInfo) {
        Image(systemName: blurSensitive ? "eye.slash" : "eye")
      }.contentTransition(.symbolEffect(.replace.downUp.byLayer))
    }
    ToolbarItem(placement: .navigationBarLeading) {
      SortButtonView()
    }
    if editMode?.wrappedValue.isEditing == true {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Delete all", systemImage: "trash", role: .destructive, action: showPopup).tint(.red)
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

  func toggleDisplaySensitiveInfo() {
    if biometricEnabled {
      appStates.authenticationActive = true
      BiometricHandler.shared.authenticateWithBiometrics { (success: Bool, error: Error?) in
        if success {
          withAnimation {
            blurSensitive.toggle()
          }
          appStates.authenticationActive = false
        } else {
          if let error = error as? LAError {
            switch error.code {
            case .userCancel, .systemCancel:
              logger.error("Authentication code userCance flailed with error: \(error.localizedDescription)")
            case .userFallback:
              logger.error("Authentication code userFallback failed with error: \(error.localizedDescription)")
            default:
              logger.error("Authentication failed with error: \(error.localizedDescription)")
            }
          }
        }
      }
    } else {
      withAnimation {
        blurSensitive.toggle()
      }
    }
  }
}
