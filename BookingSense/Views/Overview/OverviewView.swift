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
        Section("Basic Information", isExpanded: $isExpandedBasic) {
          BasicStatsView()
        }
        Section(LocalizedStringKey("\(interval.description) Insights"), isExpanded: $isExpandedMonthyInsights) {
          IntervalInsightsView()
        }
        Section("Additional Infos", isExpanded: $isAdditionalInfo) {
          AdditionalInfoView()
        }

      }.listStyle(.sidebar)
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
