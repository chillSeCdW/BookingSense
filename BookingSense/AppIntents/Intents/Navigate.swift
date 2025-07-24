// Created for BookingSense on 16.06.25 by kenny
// Using Swift 6.0

import AppIntents

struct Navigate: AppIntent {

  static let title: LocalizedStringResource = "Navigate to Tab"
  static var description = IntentDescription("Allows the user to navigate to a Tab")

  static var openAppWhenRun: Bool = true

  static var parameterSummary: some ParameterSummary {
    Summary("Navigate to \(\.$navigationOption)")
  }

  @Parameter(
    title: "Tab",
    requestValueDialog: "Which Tab?"
  )
  var navigationOption: NavigationTabOption

  @Dependency var navigator: Navigator

  func perform() async throws -> some IntentResult {
    await navigator.navigate(to: navigationOption)

    return .result()
  }
}
