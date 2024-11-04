// Created for BookingSense on 02.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TimelineEntryView: View {
  @Environment(AppStates.self) var appStates

  @StateObject var timelineEntry: TimelineEntry

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
          Text(timelineEntry.isDue.formatted())
            .foregroundStyle( timelineEntry.isDue < .now ? .red : .secondary)
        }.foregroundStyle(.secondary)
      }
    }
    .disabled(timelineEntry.state == TimelineEntryState.skipped.rawValue)
    .toggleStyle(CheckToggleStyle())
    .swipeActions {
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
        print("open Dialog for selecting Date")
      }
      .tint(.green)
    }
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
