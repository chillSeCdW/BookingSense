// Created for BookingSense on 02.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData
import WidgetKit
import BookingSenseData

struct TimelineEntryView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(AppStates.self) var appStates

  @StateObject var timelineEntry: BookingSenseData.TimelineEntry

  @State var showingConfirmation: Bool = false
  @State var isDoneOnDialogPresented: Bool = false

  var body: some View {
    Toggle(isOn: Binding(
      get: { timelineEntry.state == TimelineEntryState.done.rawValue },
      set: { isDone in
        timelineEntry.state = isDone ? TimelineEntryState.done.rawValue : TimelineEntryState.open.rawValue
        timelineEntry.completedAt = isDone ? .now : nil
        WidgetCenter.shared.reloadTimelines(ofKind: "BookingTimeWidget")
      }
    )) {
      HStack {
        Text(timelineEntry.name)
          .blur(radius: appStates.blurSensitive ? 5.0 : 0)
          .bold()
        Spacer()
        VStack(alignment: .trailing) {
          Text(timelineEntry.amount, format: .currency(code: Locale.current.currency!.identifier))
            .blur(radius: appStates.blurSensitive ? 5.0 : 0)
          DateForTimelineEntry(timelineEntry: timelineEntry)
            .foregroundStyle(getDateColor())
            .blur(radius: appStates.blurSensitive ? 5.0 : 0)
        }
        .foregroundStyle(.secondary)
      }
    }
    .disabled(timelineEntry.state == TimelineEntryState.skipped.rawValue)
    .toggleStyle(CheckToggleStyle())
    .swipeActions(edge: .trailing) {
      Button("Done on time") {
        timelineEntry.state = TimelineEntryState.done.rawValue
        timelineEntry.completedAt = timelineEntry.isDue
        WidgetCenter.shared.reloadTimelines(ofKind: "BookingTimeWidget")
      }
      .tint(.blue)
      if timelineEntry.state != TimelineEntryState.skipped.rawValue {
        Button("Skip") {
          timelineEntry.state = TimelineEntryState.skipped.rawValue
          timelineEntry.completedAt = .now
          WidgetCenter.shared.reloadTimelines(ofKind: "BookingTimeWidget")
        }
      } else {
        Button("Reopen") {
          timelineEntry.state = TimelineEntryState.open.rawValue
          timelineEntry.completedAt = nil
          WidgetCenter.shared.reloadTimelines(ofKind: "BookingTimeWidget")
        }
      }
      Button("Done on") {
        isDoneOnDialogPresented.toggle()
      }
      .tint(.green)
    }
    .swipeActions(edge: .leading) {
      Button("Delete") {
        showingConfirmation.toggle()
      }
      .tint(.red)
    }
    .sheet(isPresented: $isDoneOnDialogPresented) {
      isDoneOnDialogPresented = false
    } content: {
      DoneOnDialog(timelineEntry: timelineEntry)
        .presentationDetents([.medium, .large])
    }
    .confirmationDialog("Are you sure?", isPresented: $showingConfirmation) {
      Button("Delete \(timelineEntry.name)", role: .destructive, action: deleteTimelineEntry)
    } message: {
      // swiftlint:disable:next line_length
      Text("Sure delete entry \(timelineEntry.name) (\(timelineEntry.isDue.formatted(date: .complete, time: .omitted)))?")
    }
  }

  func deleteTimelineEntry() {
    modelContext.delete(timelineEntry)
    WidgetCenter.shared.reloadTimelines(ofKind: "BookingTimeWidget")
  }

  func getDateColor() -> Color {
    if timelineEntry.state != TimelineEntryState.open.rawValue {
      return .secondary
    }
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
    if calendar.compare(timelineEntry.isDue, to: .now, toGranularity: .day) == .orderedAscending {
      return .red
    }
    return .secondary
  }
}

struct DateForTimelineEntry: View {
  @StateObject var timelineEntry: BookingSenseData.TimelineEntry

  var body: some View {
    if let completetedAt = timelineEntry.completedAt {
      Text(completetedAt.timelineEntryFormatting())
        .foregroundStyle(getCompletedDateColor(completetedAt))
      } else {
        Text(timelineEntry.isDue.timelineEntryFormatting())
          .foregroundStyle(getDateColor())
      }
  }

  func getDateColor() -> Color {
    if timelineEntry.state != TimelineEntryState.open.rawValue {
      return .secondary
    }
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
    if calendar.compare(timelineEntry.isDue, to: .now, toGranularity: .day) == .orderedAscending {
      return .red
    }
    return .secondary
  }

  func getCompletedDateColor(_ completedAt: Date) -> Color {
    if timelineEntry.state != TimelineEntryState.skipped.rawValue {
      var calendar = Calendar(identifier: .gregorian)
      calendar.timeZone = TimeZone(identifier: "UTC")!
      if calendar.compare(completedAt, to: timelineEntry.isDue, toGranularity: .day) == .orderedDescending {
        return .red
      } else {
        return .green
      }
    }
    return .secondary
  }
}

struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(configuration.isOn ? Color.accentColor : .secondary)
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.large)
            }
        }
        .buttonStyle(.plain)
    }
}
