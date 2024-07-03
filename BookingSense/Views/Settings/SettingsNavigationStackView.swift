// Created for BookingSense on 28.06.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData
import MessageUI

struct SettingsNavigationStackView: View {
  var body: some View {
    NavigationStack {
      List {
        Section("Export/Import") {
          ExportImportButtons()
        }
        Section("Contact") {
          ContactButtons()
        }
        Section("App Store") {
          Button(action: openAppStore) {
            HStack {
              Image(systemName: "star")
              Text("Write an App Store review")
            }
          }
        }
        Section("Tip jar") {
          Button(action: openTipJar) {
            HStack {
              Image(systemName: "giftcard")
              Text("Tip jar")
            }
          }
        }
      }
      .navigationTitle("Settings")
      .listStyle(.sidebar)
    }
  }

  func openAppStore() {
    // TODO: add AppStoreLink
  }

  func openTipJar() {
    // TODO: add TipJar
  }
}

#Preview {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())

  return SettingsNavigationStackView()
    .modelContainer(factory.container)
}
