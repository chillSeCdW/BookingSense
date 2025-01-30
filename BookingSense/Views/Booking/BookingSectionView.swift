//
//  EntryListView.swift
//  BookingSense
//
//  Created by kenny on 02.05.24.
//

import SwiftUI
import SwiftData
import BookingSenseData

struct BookingSectionView: View {
  @Environment(AppStates.self) var appStates
  @Environment(\.colorScheme) var colorScheme

  var entry: BookingEntry

  var body: some View {
    NavigationLink(value: entry) {
      HStack(spacing: 0) {
        Text(entry.name)
          .blur(radius: appStates.blurSensitive ? 5 : 0)
        Spacer()
        Text(entry.amount, format: .currency(code: Locale.current.currency!.identifier))
          .contentTransition(.symbolEffect(.replace.downUp.byLayer))
          .blur(radius: appStates.blurSensitive ? 5 : 0)
      }
      .animation(.easeInOut, value: appStates.blurSensitive)
    }
    .accessibilityIdentifier("NavLink" + entry.name)
    .listRowBackground(
      Constants.getListBackgroundView(
        bookingType: entry.bookingType,
        isActive: entry.state == BookingEntryState.active.rawValue,
        colorScheme: colorScheme
      )
    )
  }
}
