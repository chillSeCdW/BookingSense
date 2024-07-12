// Created for BookingSense on 04.07.24 by kenny
// Using Swift 5.0

import SwiftUI

struct TipJarView: View {
    var body: some View {
      List {
        Button {

        } label: {
          Text("🙂 Great tip")
        }
        Button {

        } label: {
          Text("🤗 Amazing tip")
        }
        Button {

        } label: {
          Text("🤯 Extraordinary tip")
        }
        Button {

        } label: {
          Text("🫨 Ludicrous tip")
        }
      }.navigationTitle("Tips")
    }
}

#Preview {
    TipJarView()
}
