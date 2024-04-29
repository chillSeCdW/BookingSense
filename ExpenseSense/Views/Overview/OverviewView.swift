//
//  OverviewView.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 27.03.24.
//

import Foundation
import SwiftUI
import SwiftData

struct OverviewView: View {

  var body: some View {
    NavigationStack {
      List {
        BasicStats()
      }
    }
  }
}

#Preview {
  let factory = ContainerFactory(ExpenseEntry.self, storeInMemory: true)
  factory.addExamples(ContainerFactory.generateRandomEntriesItems())
  return OverviewView()
    .modelContainer(factory.container)
}
