// Created for BookingSense on 17.10.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData
import Charts

struct ChartView: View {
  var data: [BookingEntryChartData]
  var headerTitle: String

  @AppStorage("insightsInterval") private var interval: Interval = .monthly
  @AppStorage("blurSensitive") private var blurSensitive = false

  @State var selectedPie: Double?

  var highestData: (BookingEntryChartData)? {
    return data.max(by: { $0.amount < $1.amount })
  }

  var cumulativeDataRangesForStyles: [(name: String, range: Range<Double>)] {
    var cumulative = 0.0
    return data.map {
      let newCumulative = cumulative + Double(truncating: abs($0.amount) as NSNumber)
      let result = (name: $0.name, range: cumulative ..< newCumulative)
      cumulative = newCumulative
      return result
    }
  }

  var selectedStyle: (BookingEntryChartData)? {
    if let selectedPie,
       let selectedIndex = cumulativeDataRangesForStyles
      .firstIndex(where: { $0.range.contains(selectedPie) }) {
      return data[selectedIndex]
    }
    return nil
  }

  var body: some View {
    if !data.isEmpty {
      VStack {
        Text(LocalizedStringKey(headerTitle))
          .font(.title2)
          .bold()
        Chart(data, id: \.id) { element in
          SectorMark(
            angle: .value("Amount", element.amount),
            innerRadius: .ratio(0.618),
            angularInset: 1.5
          )
          .cornerRadius(5)
          .foregroundStyle(by: .value("Name", element.name))
          .opacity(element.name == (selectedStyle?.name ?? highestData?.name) ? 1 : 0.3)
        }
        .chartLegend(alignment: .center, spacing: 18)
        .chartAngleSelection(value: $selectedPie)
        .scaledToFit()
        .chartBackground { chartProxy in
          GeometryReader { geometry in
            let frame = geometry[chartProxy.plotFrame!]
            VStack {
              Text("Highest amount")
                .font(.callout)
                .foregroundStyle(.secondary)
                .opacity(selectedStyle == nil || selectedStyle?.name == highestData?.name ? 1 : 0)
              Text(LocalizedStringKey(selectedStyle?.name ?? highestData?.name ?? ""))
                .font(.title3.bold())
                .foregroundColor(.primary)
                .frame(maxWidth: frame.width/2)
              Text(selectedStyle?.amount ?? highestData?.amount ?? Decimal(),
                   format: .currency(code: Locale.current.currency!.identifier)
              ).blur(radius: blurSensitive ? 5.0 : 0)
                .font(.callout)
                .foregroundStyle(.secondary)
            }
            .position(x: frame.midX, y: frame.midY)
          }
        }
      }
    }
  }
}

#Preview {
  ChartView(data: [], headerTitle: "Monthly Minus")
}
