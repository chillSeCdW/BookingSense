//
//  OverviewView.swift
//  BookingSense
//
//  Created by kenny on 27.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct OverviewView: View {
  @AppStorage("expandedBasic") private var isExpandedBasic = true
  @AppStorage("expandedPickInsights") private var isExpandedMonthyInsights = true
  @AppStorage("expandedAdditional") private var isAdditionalInfo = false
  @AppStorage("insightsInterval") private var interval: Interval = .monthly

  var body: some View {
    NavigationStack {
      List {
        Section("Select Interval") {
          Picker("Interval", selection: $interval) {
            ForEach(Interval.allCases) { option in
              Text(String(describing: option.description))
            }
          }.accessibilityIdentifier("intervalPicker")
            .pickerStyle(.menu)
        }
        Section(LocalizedStringKey("\(interval.description) Insights"), isExpanded: $isExpandedMonthyInsights) {
          IntervalInsightsView()
        }
        Section("Additional \(interval.description) Infos", isExpanded: $isAdditionalInfo) {
          AdditionalInfoView()
        }
      }.navigationTitle("Overview")
        .listStyle(.sidebar)
    }
  }
}

#Preview {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return OverviewView()
    .environment(NavigationContext())
    .environment(ViewInfo())
    .modelContainer(factory.container)
}
