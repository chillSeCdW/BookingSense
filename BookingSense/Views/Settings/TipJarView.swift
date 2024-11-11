// Created for BookingSense on 04.07.24 by kenny
// Using Swift 5.0

import SwiftUI
import StoreKit
import OSLog

private let logger = Logger(subsystem: "BookingSense", category: "TipJarView")

struct TipJarView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
      NavigationStack {
        StoreView(ids: ["com.chill.BookingSense.tip01",
                        "com.chill.BookingSense.tip02",
                        "com.chill.BookingSense.tip03",
                        "com.chill.BookingSense.tip04"])
          .productViewStyle(.compact)
          .storeButton(.hidden, for: .cancellation)
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
      }
      .navigationTitle("Tips")
    }
}

#Preview {
    TipJarView()
}
