// Created for BookingSense on 16.06.25 by kenny
// Using Swift 6.0

import AppIntents

struct TravelTrackingAppShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: TickTimelineEntryWithBehaviour(),
      phrases: [
        "tick timeline entry in \(.applicationName)"
      ],
      shortTitle: "Tick",
      systemImageName: "checkmark.circle"
    )
    AppShortcut(
      intent: Navigate(),
      phrases: [
        "navigate to \(\.$navigationOption) in \(.applicationName)"
      ],
      shortTitle: "Navigate",
      systemImageName: "arrowshape.forward"
    )
  }
}
