// Created for BookingSense on 09.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import WidgetKit
import BookingSenseData

struct DoneOnDialog: View {
  @Environment(\.dismiss) var dismiss

  @State var date: Date = .now
  var timelineEntry: BookingSenseData.TimelineEntry

  var body: some View {
    NavigationView {
      List {
        // swiftlint:disable:next line_length
        Section("Done on Section for \(timelineEntry.name) \(timelineEntry.isDue.formatted(date: .complete, time: .omitted))") {
          DatePicker("Done on", selection: $date, displayedComponents: .date)
            .datePickerStyle(.compact)
        }
      }
      .navigationTitle("Select date")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            dismiss()
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Save") {
            timelineEntry.completedAt = date
            timelineEntry.state = TimelineEntryState.done.rawValue
            WidgetCenter.shared.reloadTimelines(ofKind: "BookingTimeWidget")
            dismiss()
          }
        }
      }
    }
  }
}
