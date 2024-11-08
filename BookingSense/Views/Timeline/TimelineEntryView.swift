// Created for BookingSense on 02.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TimelineEntryView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(AppStates.self) var appStates

  @StateObject var timelineEntry: TimelineEntry

  @State var showingConfirmation: Bool = false

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
          .bold()
        Spacer()
        VStack(alignment: .trailing) {
          Text(timelineEntry.amount, format: .currency(code: Locale.current.currency!.identifier))
          Text(timelineEntry.isDue.formatted(date: .complete, time: .omitted))
            .foregroundStyle(getDateColor())
        }.foregroundStyle(.secondary)
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
        // TODO: implement done on..
        print("open Dialog for selecting Date")
      }
      .tint(.green)
      Button("Delete") {
        showingConfirmation.toggle()
      }
      .tint(.red)
    }
    .confirmationDialog("Are you sure?", isPresented: $showingConfirmation) {
      Button("Delete \(timelineEntry.name)", role: .destructive, action: deleteTimelineEntry)
    } message: {
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
