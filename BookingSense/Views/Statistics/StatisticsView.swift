//
//  StatisticsView.swift
//  BookingSense
//
//  Created by kenny on 27.03.24.
//

import Foundation
import SwiftUI
import SwiftData
import BookingSenseData

struct StatisticsView: View {
  @State private var selectedTab = 0

  var body: some View {
    NavigationStack {
      TabView(selection: $selectedTab) {
        Tab(value: 0) {
          Text("General")
          GeneralStatsView()
        } label: {
          Label("General", systemImage: "house")
        }
        Tab(value: 1) {
          Text("Timeline")
          TimelineStatsView()
        } label: {
          Label("Timeline", systemImage: "clock")
        }
      }
      .toolbar {
        ToolbarStatisticsList()
      }
      .navigationTitle("Statistics")
      .navigationBarTitleDisplayMode(.inline)
      .tabViewStyle(.page)
      .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
  }
}

#if DEBUG
#Preview {
  let modelContainer = DataModel.shared.previewContainer
  return StatisticsView()
    .environment(AppStates())
    .modelContainer(modelContainer)
}
#endif
