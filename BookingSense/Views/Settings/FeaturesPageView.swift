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
      ProductView(id: "com.chill.BookingSense.fullAccess",
                  prefersPromotionalIcon: true
      )
      .productViewStyle(.regular)
      .storeButton(.hidden, for: .cancellation)
      .storeButton(.visible, for: .restorePurchases)
      .onAppear {
        logger.info("Creating PurchaseHandler shared instance")
        PurchaseHandler.createSharedInstance(colorScheme)
        logger.info("PurchaseHandler shared instance created")
      }
      .task {
        logger.info("Starting tasks to observe transaction updates")
        await PurchaseHandler.shared.observeTransactionUpdates()
        await PurchaseHandler.shared.checkForUnfinishedTransactions()
        logger.info("Finished checking for transactions")
      }
      InfoBox(text: "This upgrade currently includes the following features:",
              bulletPoints: ["Timeline feature"]
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
