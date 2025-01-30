//
//  Migrations.swift
//  BookingSense
//
//  Created by kenny on 29.04.24.
//

import Foundation
import SwiftData

public enum BookingMigrationV1ToV5: SchemaMigrationPlan {
  public static var schemas: [any VersionedSchema.Type] {
    [
      BookingSchemaV1.self,
      BookingSchemaV2.self,
      BookingSchemaV3.self,
      BookingSchemaV4.self,
      BookingSchemaV5.self
    ]
  }

  public static var stages: [MigrationStage] {
    [
      migrateV1ToV2,
      migrateV2ToV3,
      migrateV3ToV4,
      migrateV4ToV5
    ]
  }

  public nonisolated(unsafe) static let migrateV1ToV2 = MigrationStage.lightweight(
    fromVersion: BookingSchemaV1.self,
    toVersion: BookingSchemaV2.self
  )

  public nonisolated(unsafe) static let migrateV2ToV3 = MigrationStage.custom(fromVersion: BookingSchemaV2.self,
                                                   toVersion: BookingSchemaV3.self,
                                                   willMigrate: nil,
                                                   didMigrate: { context in
    do {
      let bookingEntries = try context.fetch(FetchDescriptor<BookingSchemaV3.BookingEntry>())

      bookingEntries.forEach { bookingEntry in
        let newBookingType: String
        switch bookingEntry.amountPrefix {
        case .plus:
          newBookingType = "plus"
        case .minus:
          newBookingType = "minus"
        case .saving:
          newBookingType = "saving"
        }
        bookingEntry.uuid = UUID().uuidString
        bookingEntry.bookingType = newBookingType
        bookingEntry.date = nil
      }
      try context.save()
      print("Migration from V2 to V3 completed successfully.")
    } catch {
      print("Failed to migrate V2 to V3: \(error)")
    }
  })

  public nonisolated(unsafe) static let migrateV3ToV4 = MigrationStage.lightweight(
    fromVersion: BookingSchemaV3.self,
    toVersion: BookingSchemaV4.self
  )

  public nonisolated(unsafe) static let migrateV4ToV5 = MigrationStage.lightweight(
    fromVersion: BookingSchemaV4.self,
    toVersion: BookingSchemaV5.self
  )

}
