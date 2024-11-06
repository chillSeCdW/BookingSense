// Created for BookingSense on 28.06.24 by kenny
// Using Swift 5.0

import SwiftUI
import SwiftData
import MessageUI
import TipKit

struct SettingsNavigationStackView: View {

  @Environment(\.colorScheme) var colorScheme
  @Environment(AppStates.self) var appStates
  @AppStorage("resetTips") var resetTips = false

  var body: some View {
    @Bindable var appStates = appStates

    NavigationStack {
      List {
        Section("Export/Import") {
          ExportImportButtons()
        }
        Section("Contact") {
          ContactButtons()
        }
        if BiometricHandler.shared.canUseAuthentication() {
          Section("Authentication") {
            Toggle("Enable Authentication for Blurring", isOn: $appStates.biometricEnabled)
            if appStates.biometricEnabled {
              Button {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                  UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
              } label: {
                HStack {
                  Image(systemName: "arrow.right.circle")
                  Text("Give Permission to activate Biometric Authentication")
                }
              }
            }
          }
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
          NavigationLink {
            TipJarView()
          } label: {
            HStack {
              Image(systemName: "giftcard")
              Text("Tip jar")
            }
          }
        }
        Section("Hints") {
          Button(action: {
            resetTips = true
            ResetHintsTopPopUp(colorScheme: colorScheme)
              .showAndStack()
              .dismissAfter(5)
          }, label: {
            HStack {
              Image(systemName: "info")
              Text("Reset hints")
            }
          })
        }

      }
      .navigationTitle("Settings")
      .listStyle(.sidebar)
    }
  }

  func openAppStore() {
    let url = "https://apps.apple.com/app/6503708794?action=write-review"
    guard let writeReviewURL = URL(string: url) else {
      fatalError("Expected a valid URL")
    }
    UIApplication.shared.open(writeReviewURL)
  }
}

#Preview {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())

  return SettingsNavigationStackView()
    .modelContainer(factory.container)
}
