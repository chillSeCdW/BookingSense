//
//  EntryFormView.swift
//  BookingSense
//
//  Created by kenny on 25.04.24.
//

import SwiftUI
import TipKit
import SwiftData

struct EntryFormView: View {
  @Environment(\.modelContext) private var modelContext

  @Binding var name: String
  @Binding var bookingType: BookingType
  @Binding var amount: String
  @Binding var interval: Interval
  @Binding var state: BookingEntryState
  @Binding var date: Date
  @Binding var dayOfEntry: Int
  @Binding var tag: Tag?
  @Binding var enableTimeline: Bool
  @Binding var useLastDayOfMonth: Bool
  @Binding var showConfirmationTimeline: Bool

  @State private var showDateNotice: Bool = false

  @FocusState var focusedName: Bool
  @FocusState var focusedAmount: Bool

  var bookingEntry: BookingEntry?

  var body: some View {
    Section(header: Text("Booking")
    ) {
      NameTextField(name: $name, focusedName: _focusedName, focusedAmount: _focusedAmount)
      BookingTypePicker(bookingType: $bookingType)
      AmountInputSection(
        amount: $amount,
        interval: $interval,
        focusedAmount: _focusedAmount
      )
    }
    TimelineSection(enableTimeline: $enableTimeline,
                    useLastDayOfMonth: $useLastDayOfMonth,
                    date: $date,
                    dayOfEntry: $dayOfEntry,
                    showNotice: $showDateNotice,
                    state: $state,
                    showConfirmationTimeline: $showConfirmationTimeline,
                    bookingEntry: bookingEntry,
                    getNextBooking: getNextBookingAsString
    )
    StatePicker(state: $state,
                enableTimeline: $enableTimeline,
                date: $date,
                showNotice: $showDateNotice,
                bookingEntry: bookingEntry
    )
    TagPicker(tag: $tag)
  }

  func getNextBookingAsString() -> String {
    let latestEntry = bookingEntry?.timelineEntries?.filter { entry in
      entry.bookingEntry?.uuid == bookingEntry?.uuid && entry.state == TimelineEntryState.open.rawValue
    }.sorted(by: { $0.isDue < $1.isDue })

    if let bookDate = bookingEntry?.date {
      var calendar = Calendar(identifier: .gregorian)
      calendar.timeZone = TimeZone(identifier: "UTC")!
      if calendar.isDate(bookDate, equalTo: date, toGranularity: .day) {
        if let entry = latestEntry?.first {
          return entry.isDue.bookingEntryNextDateFormatting()
        }
      } else {
        return date.bookingEntryNextDateFormatting()
      }
    }
    return date.bookingEntryNextDateFormatting()
  }
}

struct NameTextField: View {
  @Binding var name: String
  @FocusState var focusedName: Bool
  @FocusState var focusedAmount: Bool

  var body: some View {
    TextField(text: $name, prompt: Text("Name")) {
      Text("Name")
    }
    .toolbar {
      ToolbarItemGroup(placement: .keyboard) {
        Spacer()
        Button("Done") {
          focusedName = false
          focusedAmount = false
        }
      }
    }
    .focused($focusedName)
    .onSubmit {
      focusedAmount = true
    }
  }
}

struct BookingTypePicker: View {
  @Binding var bookingType: BookingType

  var body: some View {
    Picker("BookingType", selection: $bookingType) {
      ForEach(BookingType.allCases) { option in
        Text(LocalizedStringKey(option.description))
      }
    }
    .pickerStyle(.segmented)
    .colorMultiply(Constants.getListBackgroundColor(for: bookingType) ?? .white)
  }
}

struct AmountInputSection: View {
  @Binding var amount: String
  @Binding var interval: Interval
  @FocusState var focusedAmount: Bool

  var body: some View {
    HStack {
      Picker("Interval", selection: $interval) {
        ForEach(Interval.allCases) { option in
          Text(String(describing: option.description))
        }
      }
      .accessibilityIdentifier("intervalPicker")
      .pickerStyle(.menu)
      .labelsHidden()

      TextField(text: $amount, prompt: Text("Amount")) {
        Text("Amount")
      }
      .focused($focusedAmount)
      .multilineTextAlignment(.trailing)
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .keyboardType(.decimalPad)

      Text(Constants.getSymbol(Locale.current.currency!.identifier) ?? "$")
        .accessibilityIdentifier("CurrencySymbol")
    }
    .alignmentGuide(.listRowSeparatorLeading) { _ in
      return 0
    }
  }
}

struct TimelineSection: View {
  @Binding var enableTimeline: Bool
  @Binding var useLastDayOfMonth: Bool
  @Binding var date: Date
  @Binding var dayOfEntry: Int
  @Binding var showNotice: Bool
  @Binding var state: BookingEntryState
  @Binding var showConfirmationTimeline: Bool

  @State private var selectedMonth = 0
  @State private var selectedYear = 2024

  var bookingEntry: BookingEntry?
  var getNextBooking: () -> String

  var body: some View {
    Section(header: Text("Timeline"), footer: footerView) {
      Toggle("Enable for timeline", isOn: $enableTimeline.animation())
        .onChange(of: enableTimeline) { _, newState in
          if !newState {
            if bookingEntry?.date != nil {
              showConfirmationTimeline = true
            }
          }
        }
      if enableTimeline {
        toggleLastDayOfMonth
        if useLastDayOfMonth {
          monthYearPicker
        } else {
          startDatePicker
        }
        dateNoticeText
      }
    }
  }

  var toggleLastDayOfMonth: some View {
    Toggle("On last day of month", isOn: $useLastDayOfMonth.animation())
      .onChange(of: useLastDayOfMonth) { _, newState in
        if newState {
          dayOfEntry = 31 // setting day to last possible day of month
          var calendar = Calendar(identifier: .gregorian)
          calendar.timeZone = TimeZone(identifier: "UTC")!
          var dateComponents = calendar.dateComponents([.year, .month, .hour, .minute], from: date)
          dateComponents.day = 31

          var newDate: Date
          if let bookDate = bookingEntry?.date {
            newDate = Calendar.current.date(from: dateComponents) ?? bookDate
          } else {
            newDate = Calendar.current.date(from: dateComponents) ?? .now
          }
          date = newDate
        } else {
          dayOfEntry = 0
          if let bookDate = bookingEntry?.date {
            date = bookDate
          } else {
            date = .now
          }
        }
      }
  }

  var startDatePicker: some View {
    DatePicker("Date of first booking", selection: $date, displayedComponents: .date)
      .datePickerStyle(.compact)
  }

  var monthYearPicker: some View {
    VStack {
      Text("Select starting month")
      MonthYearPickerView(selectedDate: $date)
    }
  }

  @ViewBuilder
  var dateNoticeText: some View {
    if showNotice {
      HStack {
        Image(systemName: "exclamationmark.triangle")
        Text("Please make sure start date is set correctly")
          .font(.footnote)
          .padding(.top, 2)
      }
      .foregroundColor(.orange)
    }
  }

  var footerView: some View {
    Text(state == .active && enableTimeline ? "Next booking \(getNextBooking())" : "")
      .font(.caption)
      .foregroundStyle(.secondary)
  }
}

struct StatePicker: View {
  @Binding var state: BookingEntryState
  @Binding var enableTimeline: Bool
  @Binding var date: Date
  @Binding var showNotice: Bool

  var bookingEntry: BookingEntry?

  private var bookingEntryStateIsNotActive: Bool {
    bookingEntry?.state != BookingEntryState.active.rawValue
  }

  var body: some View {
    Section(header: Text("State of booking")) {
      Picker("State", selection: $state.animation()) {
        ForEach(BookingEntryState.allCases) { option in
          Text(String(describing: option.description))
        }
      }
      .pickerStyle(.segmented)
      .onChange(of: state) { _, newState in
        if let bookingEntry {
          if bookingEntryStateIsNotActive {
            if newState == .active {
              withAnimation {
                showNotice = true
                date = .now
              }
            } else {
              withAnimation {
                showNotice = false
                date = bookingEntry.date ?? .now
              }
            }
          }
        }
      }
    }
  }
}

struct TagPicker: View {
  @Environment(\.modelContext) private var modelContext

  @Query(sort: [SortDescriptor<Tag>(\.name, comparator: .localized)]) var tags: [Tag]
  @Binding var tag: Tag?

  @State var showingSheet: Bool = false

  var body: some View {
    Section(header: Text("Tag"), footer: Text("Useful for sorting and statistics, associated with all timeline entries")
      .font(.caption)
      .foregroundStyle(.secondary)
    ) {
      ScrollView(.horizontal) {
        HStack {
          ForEach(tags, id: \.uuid) { tagOption in
            Button(tagOption.name) {
              tag = tagOption != tag ? tagOption : nil
            }
            .buttonStyle(BorderedButtonStyle())
            .tint(tag == tagOption ? .green : .primary)
          }
          Button("Add") {
            showingSheet.toggle()
          }
          .buttonStyle(.bordered)
          .buttonStyle(BorderlessButtonStyle())
        }
      }
      .listRowInsets(EdgeInsets())
      .listRowBackground(Color.clear)
      .sheet(isPresented: $showingSheet) {
        NavigationStack {
          TagFormView()
        }
      }
    }
  }
}

#Preview {
  @Previewable @State var name: String = "testName"
  @Previewable @State var amount: String = "15,35"
  @Previewable @State var bookingType: BookingType = .plus
  @Previewable @State var interval: Interval = .weekly
  @Previewable @State var state: BookingEntryState = .active
  @Previewable @State var date: Date = .now
  @Previewable @State var dayOfEntry: Int = 0
  @Previewable @State var tag: Tag?
  @Previewable @State var enableTimeline: Bool = false
  @Previewable @State var useLastDayOfMonth: Bool = false
  @Previewable @State var showConfirmationTimeline: Bool = false

  let entry = BookingEntry(
    name: "testName",
    amount: Decimal(string: "15,35", locale: Locale(identifier: Locale.current.identifier)) ?? Decimal(),
    bookingType: BookingType.plus.rawValue,
    interval: .weekly,
    tag: nil,
    timelineEntries: nil
  )

  EntryFormView(name: $name,
                bookingType: $bookingType,
                amount: $amount,
                interval: $interval,
                state: $state,
                date: $date,
                dayOfEntry: $dayOfEntry,
                tag: $tag,
                enableTimeline: $enableTimeline,
                useLastDayOfMonth: $useLastDayOfMonth,
                showConfirmationTimeline: $showConfirmationTimeline,
                bookingEntry: entry
  )
}
