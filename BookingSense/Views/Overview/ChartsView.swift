// Created for BookingSense on 06.10.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData
import Charts

struct ChartsView: View {
  @Query private var entries: [BookingEntry]

  @AppStorage("insightsInterval") private var interval: Interval = .monthly
  @AppStorage("chartTypeIntervalMinus") var chartTypeIntervalMinus: ChartType = .interval
  @AppStorage("chartTypeIntervalPlus") var chartTypeIntervalPlus: ChartType = .interval
  @AppStorage("chartTypeIntervalSaving") var chartTypeIntervalSaving: ChartType = .interval

  var intervalMinusData: [BookingEntryChartData] {

    let minusBreakDown: [BookingEntryChartData] = entries.filter {
      $0.interval == interval.rawValue && $0.amountPrefix == .minus
    }.map { entry in
      BookingEntryChartData(id: entry.id, name: entry.name, amount: entry.amount, color: nil)
    }.sorted(by: { entry1, entry2 in
      entry1.amount > entry2.amount
    })

    return checkDataAddEmpty(minusBreakDown)
  }

  var intervalTotalMinusData: [BookingEntryChartData] {

    let minusBreakDown: [BookingEntryChartData] = entries.filter {
      $0.amountPrefix == .minus
    }.map { entry in
      if entry.interval != interval.rawValue {
        return BookingEntryChartData(
          id: entry.id,
          name: entry.name,
          amount: entry.amount * Constants.getTimesValue(from: Interval(rawValue: entry.interval), to: interval),
          color: nil
        )
      }
      return BookingEntryChartData(id: entry.id, name: entry.name, amount: entry.amount, color: nil)
    }.sorted(by: { entry1, entry2 in
      entry1.amount > entry2.amount
    })

    return checkDataAddEmpty(minusBreakDown)
  }

  var intervalPlusData: [BookingEntryChartData] {

    let plusBreakDown: [BookingEntryChartData] = entries.filter {
      $0.interval == interval.rawValue && $0.amountPrefix == .plus
    }.map { entry in
      BookingEntryChartData(id: entry.id, name: entry.name, amount: entry.amount, color: nil)
    }.sorted(by: { entry1, entry2 in
      entry1.amount > entry2.amount
    })

    return checkDataAddEmpty(plusBreakDown)
  }

  var intervalTotalPlusData: [BookingEntryChartData] {

    let plusBreakDown: [BookingEntryChartData] = entries.filter {
      $0.amountPrefix == .plus
    }.map { entry in
      if entry.interval != interval.rawValue {
        return BookingEntryChartData(
          id: entry.id,
          name: entry.name,
          amount: entry.amount * Constants.getTimesValue(from: Interval(rawValue: entry.interval), to: interval),
          color: nil
        )
      }
      return BookingEntryChartData(id: entry.id, name: entry.name, amount: entry.amount, color: nil)
    }.sorted(by: { entry1, entry2 in
      entry1.amount > entry2.amount
    })

    return checkDataAddEmpty(plusBreakDown)
  }

  var intervalSavingData: [BookingEntryChartData] {

    let savingBreakDown: [BookingEntryChartData] = entries.filter {
      $0.interval == interval.rawValue && $0.amountPrefix == .saving
    }.map { entry in
      BookingEntryChartData(id: entry.id, name: entry.name, amount: entry.amount, color: nil)
    }.sorted(by: { entry1, entry2 in
      entry1.amount > entry2.amount
    })

    return checkDataAddEmpty(savingBreakDown)
  }

  var intervalTotalSavingData: [BookingEntryChartData] {

    let savingBreakDown: [BookingEntryChartData] = entries.filter {
      $0.amountPrefix == .saving
    }.map { entry in
      if entry.interval != interval.rawValue {
        return BookingEntryChartData(
          id: entry.id,
          name: entry.name,
          amount: entry.amount * Constants.getTimesValue(from: Interval(rawValue: entry.interval), to: interval),
          color: nil
        )
      }
      return BookingEntryChartData(id: entry.id, name: entry.name, amount: entry.amount, color: nil)
    }.sorted(by: { entry1, entry2 in
      entry1.amount > entry2.amount
    })

    return checkDataAddEmpty(savingBreakDown)
  }

  var body: some View {
    if UIDevice.current.userInterfaceIdiom == .pad {
      HStack {
        chartsBody
      }
    } else {
      chartsBody
    }
  }

  @ViewBuilder
  var chartsBody: some View {
    ChartView(data: chartTypeIntervalMinus == .interval ? intervalMinusData : intervalTotalMinusData,
              headerTitle: String(localized: "\(interval.description.capitalized) Minus")
    ) {
      chartPicker($chartTypeIntervalMinus)
    }
    ChartView(data: chartTypeIntervalPlus == .interval ? intervalPlusData : intervalTotalPlusData,
              headerTitle: String(localized: "\(interval.description.capitalized) Plus")
    ) {
      chartPicker($chartTypeIntervalPlus)
    }
    ChartView(data: chartTypeIntervalSaving == .interval ? intervalSavingData : intervalTotalSavingData,
              headerTitle: String(localized: "\(interval.description.capitalized) Saving")
    ) {
      chartPicker($chartTypeIntervalSaving)
    }
  }

  func chartPicker(_ chartType: Binding<ChartType>) -> some View {
    Picker("Chart Type", selection: chartType.animation()) {
      ForEach(ChartType.allCases) { option in
        Text(LocalizedStringKey(option.description))
      }
    }
    .pickerStyle(.segmented)
  }

  func checkDataAddEmpty(_ data: [BookingEntryChartData]) -> [BookingEntryChartData] {
    if data.isEmpty {
      return [BookingEntryChartData(id: "empty", name: "No data", amount: 1, color: .gray)]
    } else {
      return data
    }
  }
}

#Preview {
  ChartsView()
}
