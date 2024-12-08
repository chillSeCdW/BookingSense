//
//  EntryView.swift
//  BookingSense
//
//  Created by kenny on 10.04.24.
//

import Foundation
import SwiftUI
import SwiftData

struct EntryEditView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) var dismiss

  @Query private var entries: [BookingEntry]

  var bookingEntry: BookingEntry?

  @State var showConfirmation: Bool = false
  @State var showConfirmationTimeline: Bool = false
  @State private var name: String = ""
  @State private var bookingType: BookingType = .minus
  @State private var amount: String = ""
  @State private var interval: Interval = .monthly
  @State private var state: BookingEntryState = .active
  @State private var date: Date = .now
  @State private var tag: Tag?
  @State private var errorMessage: String?
  @State private var enableTimeline: Bool = false
  @FocusState private var focusedName: Bool
  @FocusState private var focusedAmount: Bool
  let alertTitle: String = "Save failed"

  private var isCreate: Bool {
    bookingEntry == nil ? true : false
  }

  var body: some View {
    NavigationView {
      Form {
        EntryFormView(name: $name,
                      bookingType: $bookingType,
                      amount: $amount,
                      interval: $interval,
                      state: $state,
                      date: $date,
                      tag: $tag,
                      enableTimeline: $enableTimeline,
                      showConfirmationTimeline: $showConfirmationTimeline,
                      focusedName: _focusedName,
                      focusedAmount: _focusedAmount,
                      bookingEntry: bookingEntry
        )
        .onAppear {
          if let bookingEntry {
            name = bookingEntry.name
            bookingType = BookingType(rawValue: bookingEntry.bookingType)!
            amount = bookingEntry.amount.generateFormattedNumber()
            interval = Interval(rawValue: bookingEntry.interval) ?? Interval.monthly
            state = BookingEntryState(rawValue: bookingEntry.state) ?? BookingEntryState.active
            date = bookingEntry.date ?? .now
            tag = bookingEntry.tag
            enableTimeline = bookingEntry.date != nil
          }
        }
        if !isCreate {
          Section(content: {
            HStack {
              Button("Delete booking", systemImage: "trash", role: .destructive, action: showDeleteConfirm)
                .foregroundStyle(.red)
            }
          }, footer: {
            Text("Will also impact associated timeline entries")
          })
        }
      }
      .listSectionSpacing(.compact)
      .navigationTitle(isCreate ? "Create booking" : "Edit booking")
      .toolbar {
        ToolbarEditEntry(isCreate: isCreate,
                         save: save,
                         didValuesChange: didValuesChange,
                         dismissSheet: { dismiss() }
        )
      }
      .alert(Text(LocalizedStringKey(alertTitle)), isPresented: Binding<Bool>(
        get: { errorMessage != nil },
        set: { if !$0 { errorMessage = nil } }
      )) {
        Button("Ok", role: .cancel) {
          errorMessage = nil
        }
      } message: {
        Text(LocalizedStringKey(errorMessage ?? "An unknown error occurred."))
      }
      .confirmationDialog("Are you sure?", isPresented: $showConfirmation) {
        Button("Delete \(bookingEntry?.name ?? "booking")", role: .destructive) {
          modelContext.delete(bookingEntry!)
          dismiss()
        }
      } message: {
        Text("Sure delete booking \(bookingEntry?.name ?? ""), will delete timeline entries?")
      }
      .confirmationDialog("Are you sure?", isPresented: $showConfirmationTimeline) {
        Button("Deactivate \(bookingEntry?.name ?? "booking") timeline", role: .destructive) {
          Constants.removeTimelineEntriesFrom(bookingEntry!, context: modelContext)
          bookingEntry!.date = nil
          showConfirmationTimeline = false
          dismiss()
        }
        Button("Cancel", role: .cancel) {
          showConfirmationTimeline = false
          enableTimeline = true
        }
      } message: {
        Text("Deactivate \(bookingEntry?.name ?? "booking") timeline, will delete")
      }
    }
  }

  func showDeleteConfirm() {
    withAnimation {
      showConfirmation = true
    }
  }

  func save() {
    let sanitizedAmount = stripString(amount)
    focusedName = false
    focusedAmount = false
    let alreadyExists = entries.filter {
      $0.name == name && $0.uuid != bookingEntry?.uuid
    }.first != nil

    if alreadyExists {
      DispatchQueue.main.async {
        errorMessage = "Entry name already exists. Please use different name."
      }
      return
    }

    let parsedAmount = try? Decimal(sanitizedAmount, format: Decimal.FormatStyle(locale: Locale.current))
    if checkIfAmountWasTransformed(sanitizedAmount, parsedDecimal: parsedAmount) {
      BookingInfoPopUp(colorScheme: colorScheme, parsedAmount: parsedAmount)
        .showAndStack()
        .dismissAfter(10)
    }

    if isCreate {
      let newEntry = BookingEntry(
        name: name,
        state: state.rawValue,
        amount: parsedAmount ?? Decimal(),
        date: enableTimeline ? date : nil,
        bookingType: bookingType.rawValue,
        interval: interval,
        tag: tag,
        timelineEntries: nil
      )
      modelContext.insert(newEntry)
    } else {
      updateTimelineTags(tag, oldTag: bookingEntry!.tag, entry: bookingEntry)
      bookingEntry!.name = name
      bookingEntry!.bookingType = bookingType.rawValue
      bookingEntry!.amount = parsedAmount ?? Decimal()
      bookingEntry!.interval = interval.rawValue
      bookingEntry!.state = state.rawValue
      bookingEntry!.date = enableTimeline ? date : nil
      bookingEntry!.tag = tag
      Task {
        handleTimelineEntries(
          BookingEntryState(rawValue: bookingEntry!.state),
          entry: bookingEntry
        )
      }
    }
    dismiss()
  }

  func handleTimelineEntries(_ state: BookingEntryState?, entry: BookingEntry?) {
    guard let state = state, let entry = entry else { return }

    switch state {
    case BookingEntryState.active:
      Constants.removeTimelineEntriesNewerThan(entry, context: modelContext)
    case BookingEntryState.paused:
      Constants.removeTimelineEntriesNewerThan(.now, entry: entry, context: modelContext)
    case BookingEntryState.archived:
      Constants.removeTimelineEntriesNewerThan(.now, entry: entry, context: modelContext)
    }
  }

  func updateTimelineTags(_ newTag: Tag?, oldTag: Tag?, entry: BookingEntry?) {
    guard let entry = entry else { return }
    if newTag == oldTag {
      return
    }

    entry.timelineEntries?.forEach {
      $0.tag = newTag
    }
  }

  func checkIfAmountWasTransformed(_ amountStr: String, parsedDecimal: Decimal?) -> Bool {
    if parsedDecimal != nil {
      if (0...2).contains(amountStr.components(separatedBy: Locale.current.decimalSeparator!).count) {
        return false
      }
      if amountStr.elementsEqual(parsedDecimal!.formatted()) {
        return false
      }
      return true
    }
    return true
  }

  func didValuesChange() -> Bool {
    if let bookingEntry {
      if name != bookingEntry.name ||
          amount != bookingEntry.amount.generateFormattedNumber() ||
          bookingType.rawValue != bookingEntry.bookingType ||
          interval != Interval(rawValue: bookingEntry.interval) ?? .monthly ||
          (enableTimeline ? date : nil) != bookingEntry.date ||
          state != BookingEntryState(rawValue: bookingEntry.state) ?? .active ||
          tag != bookingEntry.tag {
        return true
      }
    }

    return false
  }

  func stripString(_ input: String) -> String {
    let pattern = "[^0-9,\\.]"
    if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
      let range = NSRange(location: 0, length: input.utf16.count)
      let modifiedString = regex.stringByReplacingMatches(in: input, options: [], range: range, withTemplate: "")
      return modifiedString
    }
    return "0"
  }
}

#Preview("Edit") {
  let entry = BookingEntry(
    name: "testName",
    amount: Decimal(string: "15,35", locale: Locale(identifier: Locale.current.identifier)) ?? Decimal(),
    bookingType: BookingType.plus.rawValue,
    interval: .weekly,
    tag: nil,
    timelineEntries: nil)

  return EntryEditView(bookingEntry: entry)
}

#Preview("Create") {
  EntryEditView()
}
