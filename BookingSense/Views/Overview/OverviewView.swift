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
  @Query private var entries: [BookingEntry]

  @AppStorage("expandedBasic") private var isExpandedBasic = true
  @AppStorage("expandedAdditional") private var isAdditionalInfo = false
  @AppStorage("expandedCharts") private var isExpandedCharts = false
  @AppStorage("insightsInterval") private var interval: Interval = .monthly

  var monthlyMinusData: [BookingEntryChartData] {

    let minusBreakDown: [BookingEntryChartData] = entries.filter {
      $0.interval == Interval.monthly.rawValue && $0.amountPrefix == .minus
    }.map { entry in
      BookingEntryChartData(id: entry.id, name: entry.name, amount: entry.amount)
    }

    return minusBreakDown
  }

  var monthlyPlusData: [BookingEntryChartData] {

    let plusBreakDown: [BookingEntryChartData] = entries.filter {
      $0.interval == Interval.monthly.rawValue && $0.amountPrefix == .plus
    }.map { entry in
      BookingEntryChartData(id: entry.id, name: entry.name, amount: entry.amount)
    }

    return plusBreakDown
  }

  var monthlySavingData: [BookingEntryChartData] {

    let savingBreakDown: [BookingEntryChartData] = entries.filter {
      $0.interval == Interval.monthly.rawValue && $0.amountPrefix == .saving
    }.map { entry in
      BookingEntryChartData(id: entry.id, name: entry.name, amount: entry.amount)
    }

    return savingBreakDown
  }

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
        Section(LocalizedStringKey("\(interval.description) Insights"), isExpanded: $isExpandedBasic) {
          OverviewChartView()
          IntervalInsightsView()
        }
        Section("Charts", isExpanded: $isExpandedCharts) {
          ChartsView(data: monthlyMinusData)
          ChartsView(data: monthlyPlusData)
          ChartsView(data: monthlySavingData)
        }
        Section("Additional \(interval.description) Infos", isExpanded: $isAdditionalInfo) {
          AdditionalInfoView()
        }
      }
      .navigationTitle("Overview")
      .listStyle(.sidebar)
      .toolbar {
        ToolbarOverviewList()
      }
    }
  }
}

#Preview {
  let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return OverviewView()
    .environment(SearchInfo())
    .modelContainer(factory.container)
}
