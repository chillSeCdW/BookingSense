// Created for BookingSense on 02.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

struct TimelineEntryView: View {
  @Environment(AppStates.self) var appStates

  @State var isDone: Bool = false

  var timelineEntry: TimelineEntry

  var body: some View {
    return
      Toggle(isOn: $isDone) {
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
        .toggleStyle(CheckToggleStyle())

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
