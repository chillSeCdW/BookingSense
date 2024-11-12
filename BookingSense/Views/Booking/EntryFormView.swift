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
  @Binding var tag: Tag?

  @State private var showDateNotice: Bool = false

  @FocusState var focusedName: Bool
  @FocusState var focusedAmount: Bool

  var bookingEntry: BookingEntry?

  private var formatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.usesGroupingSeparator = false
    return formatter
  }
  private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    formatter.timeStyle = .none
    return formatter
  }

  private var bookingEntryStateIsNotActive: Bool {
    bookingEntry?.state != BookingEntryState.active.rawValue
  }

  var body: some View {
    Section(header: Text("Booking"),
            footer: footerView
    ) {
      NameTextField(name: $name, focusedName: _focusedName, focusedAmount: _focusedAmount)
      BookingTypePicker(bookingType: $bookingType)
      AmountInputSection(
        amount: $amount,
        interval: $interval,
        focusedAmount: _focusedAmount
      )
      StartDatePicker(date: $date)
      DateNoticeText(display: $showDateNotice)
    }
    StatePicker(state: $state)
      .onChange(of: state) { _, newState in
        if let bookingEntry {
          if bookingEntryStateIsNotActive {
            if newState == .active {
              withAnimation {
                showDateNotice = true
                date = .now
              }
            } else {
              withAnimation {
                showDateNotice = false
                date = bookingEntry.date
              }
            }
          }
        }
      }
    TagPicker(tag: $tag)
      .onAppear {
        if let bookingEntry {
          name = bookingEntry.name
          bookingType = BookingType(rawValue: bookingEntry.bookingType)!
          amount = formatter.string(from: NSDecimalNumber(decimal: bookingEntry.amount)) ?? ""
          interval = Interval(rawValue: bookingEntry.interval) ?? Interval.monthly
          state = BookingEntryState(rawValue: bookingEntry.state) ?? BookingEntryState.active
          date = bookingEntry.date
          tag = bookingEntry.tag
        }
      }
  }

  var footerView: some View {
    // swiftlint:disable:next line_length
    Text(state == .active ? "Next booking \(getNextBooking(fieldDate: date, interval: interval), formatter: dateFormatter)" : "")
      .font(.caption)
      .foregroundStyle(.secondary)
  }

  func getNextBooking(fieldDate: Date, interval: Interval) -> Date {
    let latestEntry = bookingEntry?.timelineEntries?.filter { entry in
      entry.bookingEntry?.uuid == bookingEntry?.uuid && entry.state == TimelineEntryState.open.rawValue
    }.sorted(by: { $0.isDue < $1.isDue })

    if let bookDate = bookingEntry?.date {
      if Calendar.current.isDate(bookDate, equalTo: fieldDate, toGranularity: .day) {
        if let entry = latestEntry?.first {
          return entry.isDue
        }
      } else {
        return fieldDate
      }
    }
    return fieldDate
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

struct DateNoticeText: View {
  @Binding var display: Bool

  var body: some View {
    if display {
      HStack {
        Image(systemName: "exclamationmark.triangle")
        Text("Please make sure start date is set correctly")
          .font(.footnote)
          .padding(.top, 2)
      }
      .foregroundColor(.orange)
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

struct StartDatePicker: View {
  @Binding var date: Date

  var body: some View {
    DatePicker("Date of first booking", selection: $date, displayedComponents: .date)
      .datePickerStyle(.compact)
  }
}

struct StatePicker: View {
  @Binding var state: BookingEntryState

  var body: some View {
    Section(header: Text("State of booking")) {
      Picker("State", selection: $state) {
        ForEach(BookingEntryState.allCases) { option in
          Text(String(describing: option.description))
        }
      }
      .pickerStyle(.segmented)
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
          ForEach(tags) { tagOption in
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
  @Previewable @State var tag: Tag?

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
                tag: $tag,
                bookingEntry: entry
  )
}
