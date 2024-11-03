// Created for BookingSense on 02.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TimelineEntryView: View {
  @Environment(AppStates.self) var appStates

  @StateObject var timelineEntry: TimelineEntry

  var body: some View {
    Toggle(isOn: Binding(
      get: { timelineEntry.state == .done },
      set: { isDone in
        timelineEntry.state = isDone ? .done : .active
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
    .disabled(timelineEntry.state == .skipped)
    .toggleStyle(CheckToggleStyle())
    .swipeActions {
      if timelineEntry.state != .skipped {
        Button("Skip") {
          timelineEntry.state = .skipped
          timelineEntry.completedAt = .now
        }
      } else {
        Button("make Active") {
          timelineEntry.state = .active
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
