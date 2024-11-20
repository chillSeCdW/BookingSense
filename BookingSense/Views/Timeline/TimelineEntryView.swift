// Created for BookingSense on 02.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TimelineEntryView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(AppStates.self) var appStates

  @StateObject var timelineEntry: TimelineEntry

  @State var showingConfirmation: Bool = false
  @State var isDoneOnDialogPresented: Bool = false

  var body: some View {
    Toggle(isOn: Binding(
      get: { timelineEntry.state == TimelineEntryState.done.rawValue },
      set: { isDone in
        timelineEntry.state = isDone ? TimelineEntryState.done.rawValue : TimelineEntryState.open.rawValue
        timelineEntry.completedAt = isDone ? .now : nil
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
      if timelineEntry.state != TimelineEntryState.skipped.rawValue {
        Button("Skip") {
          timelineEntry.state = TimelineEntryState.skipped.rawValue
          timelineEntry.completedAt = .now
        }
      } else {
        Button("Reopen") {
          timelineEntry.state = TimelineEntryState.open.rawValue
          timelineEntry.completedAt = nil
        }
      }
      Button("Done on") {
        isDoneOnDialogPresented.toggle()
      }
      .tint(.green)
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
  }

  func getDateColor() -> Color {
    if timelineEntry.state != TimelineEntryState.open.rawValue {
      return .secondary
    }
    if Calendar.current.compare(timelineEntry.isDue, to: .now, toGranularity: .day) == .orderedAscending {
      return .red
    }
    return .secondary
  }
}

struct DateForTimelineEntry: View {
  @StateObject var timelineEntry: TimelineEntry

  private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.setLocalizedDateFormatFromTemplate("EEE ddMMyyyy")
    return formatter
  }

  var body: some View {
    if let completetedAt = timelineEntry.completedAt {
      Text(dateFormatter.string(from: completetedAt))
        .foregroundStyle(timelineEntry.state == TimelineEntryState.skipped.rawValue ? Color.secondary : .green)
      } else {
        Text(dateFormatter.string(from: timelineEntry.isDue))
          .foregroundStyle(getDateColor())
      }
  }

  func getDateColor() -> Color {
    if timelineEntry.state != TimelineEntryState.open.rawValue {
      return .secondary
    }
    if Calendar.current.compare(timelineEntry.isDue, to: .now, toGranularity: .day) == .orderedAscending {
      return .red
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
