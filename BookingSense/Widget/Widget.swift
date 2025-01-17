// Created for BookingSense on 16.01.25 by kenny
// Using Swift 6.0

import WidgetKit
import SwiftUI
import SwiftData
import BookingSenseData

struct BookingSenseTimelineProvider: AppIntentTimelineProvider {

//  let modelContext = ModelContext(ContainerFactory(
//    BookingSchemaV5.self,
//    storeInMemory: false,
//    migrationPlan: BookingMigrationV1ToV5.self).container
//  )

  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigIntent())
  }

  func snapshot(for configuration: ConfigIntent, in context: Context) async -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: configuration)
  }

  func timeline(for configuration: ConfigIntent, in context: Context) async -> Timeline<SimpleEntry> {
    var entries: [SimpleEntry] = []

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, configuration: configuration)
      entries.append(entry)
    }

    return Timeline(entries: entries, policy: .atEnd)
  }

  //    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
  //        // Generate a list containing the contexts this widget is relevant in.
  //    }
}

struct SimpleEntry: WidgetKit.TimelineEntry {
  let date: Date
  let configuration: ConfigIntent
}

struct WidgetEntryView: View {
  var entry: BookingSenseTimelineProvider.Entry

  var body: some View {
    Text("Time:")
    Text(entry.date, style: .time)

    Text("Favorite Emoji:")
    Text(entry.configuration.favoriteEmoji)

    Text("Favorite App:")
    Text(entry.configuration.favoriteApp)
  }
}

struct BookingSenseWidget: Widget {
  let kind: String = "Widget"

  var families: [WidgetFamily] {
    return [.systemSmall, .systemMedium, .systemLarge]
  }

  var body: some WidgetConfiguration {
    AppIntentConfiguration(
      kind: kind,
      intent: ConfigIntent.self,
      provider: BookingSenseTimelineProvider()
    ) { entry in
      WidgetEntryView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .supportedFamilies(families)
  }
}

extension ConfigIntent {
  fileprivate static var smiley: ConfigIntent {
    let intent = ConfigIntent()
    intent.favoriteEmoji = "😀"
    intent.favoriteApp = "GrowthTide"
    return intent
  }

  fileprivate static var starEyes: ConfigIntent {
    let intent = ConfigIntent()
    intent.favoriteEmoji = "🤩"
    intent.favoriteApp = "Fitness"
    return intent
  }
}

#Preview(as: .systemSmall) {
  BookingSenseWidget()
} timeline: {
  SimpleEntry(date: .now, configuration: .smiley)
  SimpleEntry(date: .now, configuration: .starEyes)
}
