// Created for BookingSense on 16.01.25 by kenny
// Using Swift 6.0

import WidgetKit
import SwiftUI

struct BookingTimeEntry: WidgetKit.TimelineEntry {
  let bookingTimeSnapshot: [BookingTimeSnapshot]
  let date: Date
  let configuration: ConfigIntent
}

struct BookingTimeWidget: Widget {
  @Environment(\.widgetFamily) var family

  let kind: String = "BookingTimeWidget"

  var families: [WidgetFamily] {
    return [.systemSmall, .systemMedium, .systemLarge]
  }

  var body: some WidgetConfiguration {
    AppIntentConfiguration(
      kind: kind,
      intent: ConfigIntent.self,
      provider: BookingTimelineProvider()
    ) { entry in
      WidgetTimelineListView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .configurationDisplayName("Timeline List")
    .description("Get quick access to your timeline.")
    .supportedFamilies(families)
  }
}

extension ConfigIntent {
  fileprivate static var smiley: ConfigIntent {
    let intent = ConfigIntent()
    return intent
  }
}
