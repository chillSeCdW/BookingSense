// Created for BookingSense on 03.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import LocalAuthentication
import OSLog

struct ToolbarTimelineContent: ToolbarContent {
  private let logger = Logger(subsystem: "BookingSense", category: "ToolbarTimelineContent")

  @Environment(\.editMode) private var editMode
  @Environment(AppStates.self) var appStates

  @Binding var showDeleteAllConfirm: Bool
  @Binding var showDeleteOpenConfirm: Bool

  let proxy: ScrollViewProxy

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
      Button(action: { appStates.isTimeFilterDialogPresented.toggle()},
             label: { Image(systemName: "line.horizontal.3.decrease.circle") }
      )
    }
    if editMode?.wrappedValue.isEditing == true {
      ToolbarItem(placement: .navigationBarTrailing) {
        Menu {
          Button("Delete all", systemImage: "trash.fill", role: .destructive, action: {
            withAnimation {
              showDeleteAllConfirm = true
            }
          })
          Button("Delete all open entries", systemImage: "trash", role: .destructive, action: {
            withAnimation {
              showDeleteOpenConfirm = true
            }
          })
        } label: {
          Label("Edit options", systemImage: "pencil")
        }
      }
    } else {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(
          action: {
            withAnimation {
              proxy.scrollTo("currentMonthSection", anchor: .top)
            }
          },
          label: { Text("Today") }
        )
      }
    }
    ToolbarItem(placement: .navigationBarTrailing) {
      EditButton()
    }
  }
}
