// Created for BookingSense on 22.01.25 by kenny
// Using Swift 6.0

import SwiftUI
import WidgetKit
import BookingSenseData

struct WidgetTimelineListView: View {
  @Environment(\.widgetFamily) var family

  var entry: BookingTimelineProvider.Entry

  var body: some View {
    switch family {
    case .systemSmall:
      smallWidget
    case .systemMedium:
      mediumWidget
    case .systemLarge:
      largeWidget
    default:
      smallWidget
    }
  }

  var smallWidget: some View {
    VStack(alignment: .center) {
      if entry.configuration.showHeader == .show {
        HStack(alignment: .center) {
          Spacer()
          Text("filter type \(entry.configuration.typeOfBookings.localizedStringResource)")
            .font(.title3)
            .foregroundStyle(
              getHeaderTextColor(
                for: entry.configuration.typeOfBookings
              )
            )
          Text("entry count \(entry.bookingTimeSnapshot.count)")
            .font(.title2)
            .bold()
        }
        midWidget(showDivider: false)
      }
      bottomWidget(listLength: entry.configuration.showHeader == .hide ? 4 : 3)
      Spacer()
    }
  }

  var mediumWidget: some View {
    HStack {
      if entry.configuration.showHeader == .show {
        VStack(alignment: .leading) {
          Spacer()
          Text("entry count \(entry.bookingTimeSnapshot.count)")
            .font(.largeTitle)
          Text("filter type \(entry.configuration.typeOfBookings.localizedStringResource)")
            .font(.title2)
            .foregroundStyle(
              getHeaderTextColor(
                for: entry.configuration.typeOfBookings
              )
            )
        }
        midWidget()
      }
      bottomWidget(listLength: 4)
    }
  }

  var largeWidget: some View {
    VStack {
      if entry.configuration.showHeader == .show {
        HStack(alignment: .center) {
          Spacer()
          Text("filter type \(entry.configuration.typeOfBookings.localizedStringResource)")
            .font(.title2)
            .foregroundStyle(
              getHeaderTextColor(
                for: entry.configuration.typeOfBookings
              )
            )
          Text("entry count \(entry.bookingTimeSnapshot.count)")
            .font(.largeTitle)
            .bold()
        }
        midWidget()
      }
      bottomWidget(listLength: entry.configuration.showHeader == .hide ? 9 : 7)
      Spacer()
    }
  }

  @ViewBuilder
  func midWidget(showDivider: Bool = true) -> some View {
    if showDivider {
      Divider()
    }
  }

  @ViewBuilder
  func bottomWidget(listLength: Int) -> some View {
    if entry.bookingTimeSnapshot.isEmpty {
      Spacer()
      Text("No entries found.")
      Spacer()
    } else {
      VStack(alignment: .center) {
        ForEach(entry.bookingTimeSnapshot.prefix(listLength)) { snapshot in
          entryLine(snapshot)
        }
      }
    }
  }

  @ViewBuilder
  func entryLine(_ snapshot: BookingTimeSnapshot) -> some View {
    HStack {
      Toggle(isOn: snapshot.completedAt != nil,
             intent: CheckMarkTL(
              uuid: snapshot.uuid,
              typeOfChecking: entry.configuration.checkBehaviour
             )
      ) {}
        .toggleStyle(CheckToggleStyle(
          bookingType: BookingType(rawValue: snapshot.bookingType),
          coloredToggle: entry.configuration.colorToggle
        ))
      VStack(alignment: .leading) {
        Text(snapshot.name)
          .lineLimit(1)
          .font(.body)
        DateForTimelineEntry(timelineSnapshot: snapshot)
          .font(.footnote)
          .lineLimit(1)
          .foregroundStyle(getDateColor(timelineSnapshot: snapshot))
      }
      Spacer()
    }
  }

  func getDateColor(timelineSnapshot: BookingTimeSnapshot) -> Color {
    if timelineSnapshot.state != TimelineEntryState.open.rawValue {
      return .secondary
    }
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
    if calendar.compare(timelineSnapshot.isDue, to: .now, toGranularity: .day) == .orderedAscending {
      return .red
    }
    return .secondary
  }

  func getHeaderTextColor(for bookingType: BookingSenseWidgetContentType) -> Color {
    switch bookingType {
    case .all:
      return .primary
    default:
      let type = BookingType(rawValue: bookingType.rawValue) ?? .minus
      return StyleHelper.listBackgroundColors[type] ?? .primary
    }
  }
}

struct DateForTimelineEntry: View {
  var timelineSnapshot: BookingTimeSnapshot

  var body: some View {
    if let completetedAt = timelineSnapshot.completedAt {
      Text(completetedAt.timelineEntryShortFormatting())
        .foregroundStyle(getCompletedDateColor(completetedAt))
    } else {
      Text(timelineSnapshot.isDue.timelineEntryShortFormatting())
        .foregroundStyle(getDateColor())
    }
  }

  func getDateColor() -> Color {
    if timelineSnapshot.state != TimelineEntryState.open.rawValue {
      return .secondary
    }
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
    if calendar.compare(timelineSnapshot.isDue, to: .now, toGranularity: .day) == .orderedAscending {
      return .red
    }
    return .secondary
  }

  func getCompletedDateColor(_ completedAt: Date) -> Color {
    if timelineSnapshot.state != TimelineEntryState.skipped.rawValue {
      var calendar = Calendar(identifier: .gregorian)
      calendar.timeZone = TimeZone(identifier: "UTC")!
      if calendar.compare(completedAt, to: timelineSnapshot.isDue, toGranularity: .day) == .orderedDescending {
        return .red
      } else {
        return .green
      }
    }
    return .secondary
  }
}

struct CheckToggleStyle: ToggleStyle {
  let bookingType: BookingType?
  let coloredToggle: BookingSenseWidgetColoredToggle

  func makeBody(configuration: Configuration) -> some View {
    Button {
      configuration.isOn.toggle()
    } label: {
      Label {
        configuration.label
      } icon: {
        Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
          .foregroundStyle(
            configuration.isOn ?
            Color.accentColor :
              getIconColor(for: bookingType, enableColor: coloredToggle)
          )
          .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
          .imageScale(.large)
      }
    }
    .buttonStyle(.plain)
  }

  func getIconColor(
    for bookingType: BookingType?,
    enableColor: BookingSenseWidgetColoredToggle
  ) -> Color {
    if enableColor == .black {
      return .secondary
    }
    if let bookingType = bookingType {
      return StyleHelper.listBackgroundColors[bookingType] ?? .secondary
    }
    return .secondary
  }
}

#Preview("Small Widget", as: .systemSmall) {
  BookingTimeWidget()
} timeline: {
  BookingTimeEntry(
    bookingTimeSnapshot: [BookingTimeSnapshot(uuid: "someUUID",
                                              name: "example name",
                                              bookingType: "minus",
                                              amount: 50,
                                              isDue: .now,
                                              state: TimelineEntryState.open.rawValue,
                                              completedAt: nil
                                             )],
    date: .now,
    configuration: ConfigIntent()
  )
}

#Preview("Medium Widget", as: .systemMedium) {
  BookingTimeWidget()
} timeline: {
  BookingTimeEntry(
    bookingTimeSnapshot: [BookingTimeSnapshot(uuid: "someUUID",
                                              name: "example name",
                                              bookingType: "minus",
                                              amount: 50,
                                              isDue: .now,
                                              state: TimelineEntryState.open.rawValue,
                                              completedAt: nil
                                             )],
    date: .now,
    configuration: ConfigIntent()
  )
}

#Preview("Large Widget", as: .systemLarge) {
  BookingTimeWidget()
} timeline: {
  BookingTimeEntry(
    bookingTimeSnapshot: [BookingTimeSnapshot(uuid: "someUUID",
                                              name: "example name",
                                              bookingType: "minus",
                                              amount: 50,
                                              isDue: .now,
                                              state: TimelineEntryState.open.rawValue,
                                              completedAt: nil
                                             )],
    date: .now,
    configuration: ConfigIntent()
  )
}
