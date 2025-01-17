// Created for BookingSense on 16.01.25 by kenny
// Using Swift 6.0

import WidgetKit
import AppIntents

struct ConfigIntent: WidgetConfigurationIntent {
  static var title: LocalizedStringResource { "Configuration" }
  static var description: IntentDescription { "This is an example widget." }

  // An example configurable parameter.
  @Parameter(title: "Favorite Emoji", default: "😃")
  var favoriteEmoji: String

  @Parameter(title: "Favorite App", default: "BookingSense")
  var favoriteApp: String
}
