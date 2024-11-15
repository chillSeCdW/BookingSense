// Created for BookingSense on 10.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import StoreKit
import OSLog

private let logger = Logger(subsystem: "BookingSense", category: "UpgradePageView")

struct FeaturesPageView: View {
  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    NavigationStack {
      InfoBox(text: "This upgrade currently includes the following features:",
              bulletPoints: ["Timeline feature"]
      )
      StoreView(ids: ["com.chill.BookingSense.fullAccess"],
                  prefersPromotionalIcon: true
      )
      .productViewStyle(.automatic)
      .storeButton(.hidden, for: .cancellation)
    }
    .navigationTitle("Features")
  }
}

struct InfoBox: View {
  var text: String
  var bulletPoints: [String]

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(text)
        .font(.body)
        .foregroundColor(.primary)
        .padding(.bottom, 5)

      ForEach(bulletPoints, id: \.self) { bullet in
        HStack(alignment: .top) {
          Text("•")
            .font(.body)
            .foregroundColor(.primary)
            .padding(.trailing, 5)
          Text(bullet)
            .font(.body)
            .foregroundColor(.primary)
            .bold()
            .fixedSize(horizontal: false, vertical: true)
        }
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(10)
    .shadow(radius: 3)
    .padding(.horizontal)
  }
}

#Preview {
  FeaturesPageView()
}
