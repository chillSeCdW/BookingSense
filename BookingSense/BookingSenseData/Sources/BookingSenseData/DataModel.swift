// Created for BookingSenseData on 20.01.25 by kenny
// Using Swift 6.0

import SwiftUI
import SwiftData

public actor DataModel {
  public struct TransactionAuthor {
    public static let widget = "widget"
  }

  public static let shared = DataModel()
  private init() {}

  public nonisolated lazy var modelContainer: ModelContainer = {
    #if DEBUG
    if CommandLine.arguments.contains("enable-testing-empty") {
      let factory = ContainerFactory(BookingSchemaV5.self, storeInMemory: true)
      return factory.container
    }
    #endif
    return ContainerFactory(
      BookingSchemaV5.self,
      storeInMemory: false,
      migrationPlan: BookingMigrationV1ToV5.self
    ).container
  }()
}
