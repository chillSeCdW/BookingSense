//
//  VerticalLabelStyle.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 21.04.24.
//

import SwiftUI

struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon.font(.headline)
            configuration.title.font(.footnote)
        }
    }
}
