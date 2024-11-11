// Created for BookingSense on 02.10.24 by kenny
// Using Swift 6.0

import StoreKit
import OSLog
import SwiftUICore

class PurchaseHandler {
  private let logger = Logger(subsystem: "BookingSense", category: "PurchaseHandler")

  private let colorScheme: ColorScheme

  private(set) static var shared: PurchaseHandler!

  init(colorScheme: ColorScheme) {
    self.colorScheme = colorScheme
  }

  static func createSharedInstance(_ colorScheme: ColorScheme) {
    shared = PurchaseHandler(colorScheme: colorScheme)
  }

  func process(transaction verificationResult: VerificationResult<StoreKit.Transaction>) async {
    do {
      let unsafeTransaction = verificationResult.unsafePayloadValue
      logger.log("""
            Processing transaction ID \(unsafeTransaction.id) for \
            \(unsafeTransaction.productID)
            """)
    }

    let transaction: StoreKit.Transaction

    switch verificationResult {
    case .verified(let trx):
      logger.debug("""
            Transaction ID \(trx.id) for \(trx.productID) is verified
            """)
      transaction = trx
    case .unverified(let trx, let error):
      logger.error("""
            Transaction ID \(trx.id) for \(trx.productID) is unverified: \(error)
            """)
      return
    }

    switch transaction.productType {
      case .nonConsumable:
      await transaction.finish()
      unlockFeature(transaction.productID)
      ThankYouPopUp(colorScheme: colorScheme)
        .showAndStack()
        .dismissAfter(2)
      logger.debug("""
            Finished transaction ID \(transaction.id) for \
            \(transaction.productID)
            """)
      break
      case .consumable:
      await transaction.finish()
      ThankYouPopUp(colorScheme: colorScheme)
        .showAndStack()
        .dismissAfter(2)
      logger.debug("""
            Finished transaction ID \(transaction.id) for \
            \(transaction.productID)
            """)
      break
    default:
      await transaction.finish()
      break
    }
  }

  func checkForUnfinishedTransactions() async {
    logger.debug("Checking for unfinished transactions")
    for await transaction in Transaction.unfinished {
      let unsafeTransaction = transaction.unsafePayloadValue
      logger.log("""
            Processing unfinished transaction ID \(unsafeTransaction.id) for \
            \(unsafeTransaction.productID)
            """)
      Task.detached(priority: .background) {
        await self.process(transaction: transaction)
      }
    }
    logger.debug("Finished checking for unfinished transactions")
  }

  func observeTransactionUpdates() async {
    logger.debug("Observing transaction updates")
    for await update in Transaction.updates {
      await self.process(transaction: update)
    }
  }

  func unlockFeature(_ productID: String) {
    if productID == "com.chill.BookingSense.fullAccess" {
      logger.debug("setting fullAccess Flag")
      UserDefaults.standard.set(true, forKey: "purchasedFullAccessUnlock")
    }
  }
}
