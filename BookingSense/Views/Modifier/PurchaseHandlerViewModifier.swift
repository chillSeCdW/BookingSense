// Created for BookingSense on 15.11.24 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData
import OSLog

private let logger = Logger(subsystem: "BookingSense", category: "PurchaseHandlerViewModifier")

struct PurchaseHandlerViewModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        ZStack {
            content
        }
        .purchaseAccessStatusTask()
        .onAppear {
            logger.info("Creating PurchaseHandler shared instance")
            PurchaseHandler.createSharedInstance(colorScheme)
            logger.info("PurchaseHandler shared instance created")
        }
        .task {
            logger.info("Starting tasks to observe transaction updates")
            // Begin observing StoreKit transaction updates in case a
            // transaction happens on another device.
            await PurchaseHandler.shared.observeTransactionUpdates()
            // Check if we have any unfinished transactions where we
            // need to grant access to content
            await PurchaseHandler.shared.checkForUnfinishedTransactions()
            logger.info("Finished checking for unfinished transactions")
        }
    }
}

extension View {
    func purchaseHandler() -> some View {
        modifier(PurchaseHandlerViewModifier())
    }
}
