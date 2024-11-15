// Created for BookingSense on 02.10.24 by kenny
// Using Swift 6.0

import StoreKit
import OSLog
import SwiftUICore

actor PurchaseHandler {
  private let logger = Logger(subsystem: "BookingSense", category: "PurchaseHandler")

  private var updatesTask: Task<Void, Never>?

  private let colorScheme: ColorScheme

  private(set) static var shared: PurchaseHandler!

  init(colorScheme: ColorScheme) {
    self.colorScheme = colorScheme
  }

  static func createSharedInstance(_ colorScheme: ColorScheme) {
    shared = PurchaseHandler(colorScheme: colorScheme)
  }

  func status(for verificationResult: VerificationResult<StoreKit.Transaction>?, ids: PurchaseIdentifiers) -> PurchaseStatus {
    if let verificationResult {
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
        return .defaultAccess
      }
      return PurchaseStatus(productID: transaction.productID, ids: ids) ?? .defaultAccess
    }

    return .defaultAccess
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
      logger.debug("""
            Finished transaction ID \(transaction.id) for \
            \(transaction.productID)
            """)
      if transaction.revocationReason != nil {
        return
      }
      ThankYouPopUp(colorScheme: colorScheme,
                    message: String(localized: "Thank you for upgrading and enjoy")
      )
      .showAndStack()
      .dismissAfter(3)
    case .consumable:
      await transaction.finish()
      logger.debug("""
            Finished transaction ID \(transaction.id) for \
            \(transaction.productID)
            """)
      if transaction.revocationReason != nil {
        return
      }
      ThankYouPopUp(colorScheme: colorScheme,
                    message: String(localized: "Thank you for your tip!")
      )
      .showAndStack()
      .dismissAfter(3)
    default:
      await transaction.finish()
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
    self.updatesTask = Task { [weak self] in
      self?.logger.debug("Observing transaction updates")
      for await update in Transaction.updates {
        guard let self else { break }
        await self.process(transaction: update)
      }
    }
  }
}
