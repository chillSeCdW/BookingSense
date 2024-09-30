// Created for BookingSense on 04.07.24 by kenny
// Using Swift 5.0

import SwiftUI
import StoreKit
import OSLog

private let logger = Logger(subsystem: "BookingSense", category: "TipJarView")

struct TipJarView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
      StoreView(ids: ["com.chill.BookingSense.tip01",
                      "com.chill.BookingSense.tip02",
                      "com.chill.BookingSense.tip03",
                      "com.chill.BookingSense.tip04"])
        .productViewStyle(.compact)
        .storeButton(.hidden, for: .cancellation)
        .onInAppPurchaseStart { purchase in
          print("In-App Purchase Started: \(purchase)")
        }
        .onInAppPurchaseCompletion { _, result in
          if case .success(.success(let verificationResult)) = result {
            switch verificationResult {
            case .verified(let transaction):
                logger.debug("""
                Transaction ID \(transaction.id) for \(transaction.productID) is verified
                """)
                await transaction.finish()
                ThankYouPopUp(colorScheme: colorScheme)
                  .showAndStack()
                  .dismissAfter(2)
                return
            case .unverified(let transaction, let error):
                logger.error("""
                Transaction ID \(transaction.id) for \(transaction.productID) is unverified: \(error)
                """)
                return
            }
          }
          if case .failure(let err) = result {
            logger.error("""
            Transaction failed with: \(err)
            """)
            return
          }
        }
    }
}

#Preview {
    TipJarView()
}
