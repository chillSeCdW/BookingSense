//
//  EntryListView.swift
//  BookingSense
//
//  Created by kenny on 02.05.24.
//

import SwiftUI
import SwiftData

struct BookingSectionView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(AppStates.self) var appStates
  @Environment(\.colorScheme) var colorScheme

  var entries: [BookingEntry]

  var body: some View {
    ForEach(entries, id: \.self) { entry in
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
          amountPrefix: entry.amountPrefix,
          isActive: entry.state == BookingEntryState.active.rawValue,
          colorScheme: colorScheme
        )
      )
    }
  }
}

#Preview {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return BookingSectionView(entries: [])
    .modelContainer(factory.container)
}
