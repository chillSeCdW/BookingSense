//
//  BarView.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 21.04.24.
//

import SwiftUI

struct DeleteAllButtonView: View {
  @Environment(\.editMode) private var editMode
  @State private var showingConfirmation = false
  var deleteEntries: (() -> Void)

  var body: some View {
    Button(action: showPopup) {
        Label("Delete All", systemImage: "trash")
        .labelStyle(VerticalLabelStyle())
    }.confirmationDialog("Are you sure?", isPresented: $showingConfirmation) {
      Button("Delete all entries", action: deleteEntries)
    } message: {
      Text("Are you sure you want to delete all entries?")
    }
  }

  func showPopup() {
    showingConfirmation = true
  }
}
