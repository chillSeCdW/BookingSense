// Created for BookingSense on 15.11.24 by kenny
// Using Swift 6.0

import StoreKit
import SwiftUI
import OSLog

private let logger = Logger(subsystem: "BookingSense", category: "PurchaseStatusTaskModifier")

private struct PurchaseStatusTaskModifier: ViewModifier {
  @Environment(\.accessIDs) private var accessIDs

  @State private var state: EntitlementTaskState<PurchaseStatus> = .loading

  private var isLoading: Bool {
    if case .loading = state { true } else { false }
  }

  func body(content: Content) -> some View {
    content
      .currentEntitlementTask(for: accessIDs.fullAccess) { verificationResult in
        guard let purchaseHandler = PurchaseHandler.shared else { fatalError("PurchaseHandler was nil.") }
        self.state = await verificationResult.map { @Sendable [accessIDs] statuses in
          await purchaseHandler.status(
            for: statuses,
            ids: accessIDs
          )
        }
        switch self.state {
        case .failure(let error):
          logger.error("Failed to check purchase status: \(error)")
        case .success(let status):
          logger.info("successfully set environment purchase status to \(status.description)")
        case .loading: break
        @unknown default: break
        }
        logger.info("Finished checking purchase status")
      }
      .environment(\.purchaseStatus, state.value ?? .defaultAccess)
      .environment(\.purchaseStatusIsLoading, isLoading)
  }
}

extension EnvironmentValues {

  private enum PurchaseEnvironmentKey: EnvironmentKey {
    static var defaultValue: PurchaseStatus = .defaultAccess
  }

  private enum PurchaseLoadingEnvironmentKey: EnvironmentKey {
    static var defaultValue = true
  }

  fileprivate(set) var purchaseStatus: PurchaseStatus {
    get { self[PurchaseEnvironmentKey.self] }
    set { self[PurchaseEnvironmentKey.self] = newValue }
  }

  fileprivate(set) var purchaseStatusIsLoading: Bool {
    get { self[PurchaseLoadingEnvironmentKey.self] }
    set { self[PurchaseLoadingEnvironmentKey.self] = newValue }
  }

}

extension View {

  func purchaseAccessStatusTask() -> some View {
    modifier(PurchaseStatusTaskModifier())
  }

}
