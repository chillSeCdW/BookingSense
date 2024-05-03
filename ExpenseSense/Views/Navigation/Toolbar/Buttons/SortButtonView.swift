//
//  SortButtonView.swift
//  BookingSense
//
//  Created by kenny on 24.04.24.
//

import SwiftUI

struct SortButtonView: View {
    @Environment(ViewInfo.self) private var viewInfo

    var body: some View {
        @Bindable var viewModel = viewInfo

        Menu {
            Picker("Sort Order", selection: $viewModel.sortOrder) {
                ForEach([SortOrder.forward, .reverse], id: \.self) { order in
                    Text(order.name)
                }
            }
            Picker("Sort By", selection: $viewModel.sortParameter) {
                ForEach(SortParameter.allCases) { parameter in
                    Text(parameter.name)
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
        .pickerStyle(.inline)
    }
}

extension SortOrder {
    var name: String {
        switch self {
        case .forward: "Forward"
        case .reverse: "Reverse"
        }
    }
}

enum SortParameter: String, CaseIterable, Identifiable {
    case name, amount
    var id: Self { self }
    var name: String { rawValue.capitalized }
}

#Preview {
    SortButtonView()
        .environment(ViewInfo())
}
