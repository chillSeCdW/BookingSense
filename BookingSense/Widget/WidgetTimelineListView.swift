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
      HStack(alignment: .center) {
        Spacer()
        Text("\(entry.configuration.typeOfBookings.localizedStringResource)")
          .font(.title3)
          .foregroundStyle(
            getListBackgroundColor(
              for: entry.configuration.typeOfBookings
            )
          )
        Text("\(entry.bookingTimeSnapshot.count)")
          .font(.title2)
          .bold()
      }
      midWidget(showDivider: false)
      ForEach(entry.bookingTimeSnapshot.prefix(3)) { snapshot in
        bottomWidget(snapshot)
      }
      Spacer()
    }
  }

  var mediumWidget: some View {
    HStack {
      VStack(alignment: .leading) {
        Spacer()
        Text("\(entry.bookingTimeSnapshot.count)")
          .font(.largeTitle)
        Text("\(entry.configuration.typeOfBookings.localizedStringResource)")
          .font(.title2)
          .foregroundStyle(
            getListBackgroundColor(
              for: entry.configuration.typeOfBookings
            )
          )
      }
      midWidget()
      VStack(alignment: .center) {
        ForEach(entry.bookingTimeSnapshot.prefix(4)) { snapshot in
          bottomWidget(snapshot)
        }
        Spacer()
      }
    }
  }

  var largeWidget: some View {
    VStack {
      HStack(alignment: .center) {
        Spacer()
        Text("\(entry.configuration.typeOfBookings.localizedStringResource)")
          .font(.title2)
          .foregroundStyle(
            getListBackgroundColor(
              for: entry.configuration.typeOfBookings
            )
          )
        Text("\(entry.bookingTimeSnapshot.count)")
          .font(.largeTitle)
          .bold()
      }
      midWidget()
      VStack(alignment: .center) {
        ForEach(entry.bookingTimeSnapshot.prefix(7)) { snapshot in
          bottomWidget(snapshot)
        }
      }
      Spacer()
    }
  }

  @ViewBuilder
  func midWidget(showDivider: Bool = true) -> some View {
    if showDivider {
      Divider()
    }
    if entry.bookingTimeSnapshot.isEmpty {
      Spacer()
      Text("No entries found.")
      Spacer()
    }
  }

  @ViewBuilder
  func bottomWidget(_ snapshot: BookingTimeSnapshot) -> some View {
    HStack {
      Toggle(isOn: snapshot.completedAt != nil, intent: CheckMarkTL(uuid: snapshot.uuid)) {}
        .toggleStyle(CheckToggleStyle(bookingType: BookingType(rawValue: snapshot.bookingType) ?? .minus))
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

  func getListBackgroundColor(for bookingType: BookingSenseWidgetContentType) -> Color {
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
        .foregroundStyle(timelineSnapshot.state == TimelineEntryState.skipped.rawValue ? Color.secondary : .green)
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
}

struct CheckToggleStyle: ToggleStyle {
  let bookingType: BookingType

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
              StyleHelper.getListBackgroundColor(for: bookingType) ?? .secondary
          )
          .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
          .imageScale(.large)
      }
    }
    .buttonStyle(.plain)
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
