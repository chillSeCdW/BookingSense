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
  @State private var isExpandedBasic = true
  @State private var isExpandedMonthy = true

  var body: some View {
    NavigationStack {
      List {
        Section("Basic Information", isExpanded: $isExpandedBasic) {
          BasicStatsView()
        }
        Section("Helpful Infos", isExpanded: $isExpandedMonthy) {
          HelpfulInfoView()
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
