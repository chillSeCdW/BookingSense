// Created for BookingSense on 10.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import StoreKit
import OSLog

private let logger = Logger(subsystem: "BookingSense", category: "UpgradePageView")

struct FeaturesPageView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.purchaseStatus) private var purchaseStatus

  var body: some View {
    NavigationStack {
      StoreView(ids: ["com.chill.BookingSense.fullAccess"],
                prefersPromotionalIcon: true
      )
      .productViewStyle(.automatic)
      .storeButton(.hidden, for: .cancellation)
      InfoBox(text: String(localized: "This upgrade currently includes the following features"),
              bulletPoints: [String(localized: "Timeline feature")]
      )
      InfoBox(text: String(localized: "Currently in \(purchaseStatus.description)"),
              bulletPoints: []
      )
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
