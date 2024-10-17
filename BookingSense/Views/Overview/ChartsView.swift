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
      BookingEntryChartData(id: entry.id, name: entry.name, amount: entry.amount)
    }

    return minusBreakDown
  }

  var intervalTotalMinusData: [BookingEntryChartData] {

    let minusBreakDown: [BookingEntryChartData] = entries.filter {
      $0.amountPrefix == .minus
    }.map { entry in
      if entry.interval != interval.rawValue {
        return BookingEntryChartData(
          id: entry.id,
          name: entry.name,
          amount: entry.amount * Constants.getTimesValue(from: Interval(rawValue: entry.interval), to: interval))
      }
      return BookingEntryChartData(id: entry.id, name: entry.name, amount: entry.amount)
    }

    return minusBreakDown
  }

  var intervalPlusData: [BookingEntryChartData] {

    let plusBreakDown: [BookingEntryChartData] = entries.filter {
      $0.interval == interval.rawValue && $0.amountPrefix == .plus
    }.map { entry in
      BookingEntryChartData(id: entry.id, name: entry.name, amount: entry.amount)
    }

    return plusBreakDown
  }

  var intervalTotalPlusData: [BookingEntryChartData] {

    let plusBreakDown: [BookingEntryChartData] = entries.filter {
      $0.amountPrefix == .plus
    }.map { entry in
      if entry.interval != interval.rawValue {
        return BookingEntryChartData(
          id: entry.id,
          name: entry.name,
          amount: entry.amount * Constants.getTimesValue(from: Interval(rawValue: entry.interval), to: interval))
      }
      return BookingEntryChartData(id: entry.id, name: entry.name, amount: entry.amount)
    }

    return plusBreakDown
  }

  var intervalSavingData: [BookingEntryChartData] {

    let savingBreakDown: [BookingEntryChartData] = entries.filter {
      $0.interval == interval.rawValue && $0.amountPrefix == .saving
    }.map { entry in
      BookingEntryChartData(id: entry.id, name: entry.name, amount: entry.amount)
    }

    return savingBreakDown
  }

  var intervalTotalSavingData: [BookingEntryChartData] {

    let savingBreakDown: [BookingEntryChartData] = entries.filter {
      $0.amountPrefix == .saving
    }.map { entry in
      if entry.interval != interval.rawValue {
        return BookingEntryChartData(
          id: entry.id,
          name: entry.name,
          amount: entry.amount * Constants.getTimesValue(from: Interval(rawValue: entry.interval), to: interval))
      }
      return BookingEntryChartData(id: entry.id, name: entry.name, amount: entry.amount)
    }

    return savingBreakDown
  }

  var body: some View {
    chartBody($chartTypeIntervalMinus,
              intervalData: intervalMinusData,
              totalData: intervalTotalMinusData,
              headerTitle: String(localized: "\(interval.description.capitalized) Minus"))
    chartBody($chartTypeIntervalPlus,
              intervalData: intervalPlusData,
              totalData: intervalTotalPlusData,
              headerTitle: String(localized: "\(interval.description.capitalized) Plus"))
    chartBody($chartTypeIntervalSaving,
              intervalData: intervalSavingData,
              totalData: intervalTotalSavingData,
              headerTitle: String(localized: "\(interval.description.capitalized) Saving"))
  }

  func chartBody(_ chartType: Binding<ChartType>,
                 intervalData: [BookingEntryChartData],
                 totalData: [BookingEntryChartData],
                 headerTitle: String) -> some View {
    VStack {
      Picker("Chart Type", selection: chartType) {
        ForEach(ChartType.allCases) { option in
          Text(LocalizedStringKey(option.description))
        }
      }
      .pickerStyle(.segmented)
      switch chartType.wrappedValue {
      case .interval:
        ChartView(data: intervalData, headerTitle: headerTitle)
      case .total:
        ChartView(data: totalData, headerTitle: headerTitle)
      }
    }
  }
}

#Preview {
  ChartsView()
}
