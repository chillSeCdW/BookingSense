// Created for BookingSense on 10.12.24 by kenny
// Using Swift 6.0

import SwiftUI

struct MonthYearPickerView: UIViewRepresentable {
  @Binding var selectedDate: Date

  func makeUIView(context: Context) -> UIDatePicker {
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .yearAndMonth
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)
    datePicker.calendar = Calendar(identifier: .gregorian)
    datePicker.locale = Locale.current
    datePicker.minimumDate = Calendar.current.date(from: DateComponents(year: 2000, month: 1))
    return datePicker
  }

  func updateUIView(_ uiView: UIDatePicker, context: Context) {
    uiView.date = selectedDate
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject {
    var parent: MonthYearPickerView

    init(_ parent: MonthYearPickerView) {
      self.parent = parent
    }

    @objc func dateChanged(_ sender: UIDatePicker) {
      parent.selectedDate = sender.date
    }
  }
}
