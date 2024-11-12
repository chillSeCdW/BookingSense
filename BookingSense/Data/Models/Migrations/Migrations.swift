//
//  Migrations.swift
//  BookingSense
//
//  Created by kenny on 29.04.24.
//

import Foundation
import SwiftData

enum ExpenseMigrationV1ToV3: SchemaMigrationPlan {
  static var schemas: [any VersionedSchema.Type] {
    [
      BookingSchemaV1.self,
      BookingSchemaV2.self,
      BookingSchemaV3.self,
      BookingSchemaV4.self
    ]
  }

  static var stages: [MigrationStage] {
    [
      migrateV1ToV2,
      migrateV2ToV3,
      migrateV3ToV4
    ]
  }

  static let migrateV1ToV2 = MigrationStage.lightweight(
    fromVersion: BookingSchemaV1.self,
    toVersion: BookingSchemaV2.self
  )
  //  static let migrateV2ToV3 = MigrationStage.lightweight(
  //    fromVersion: BookingSchemaV2.self,
  //    toVersion: BookingSchemaV3.self
  //  )
  static let migrateV2ToV3 = MigrationStage.custom(fromVersion: BookingSchemaV2.self,
                                                   toVersion: BookingSchemaV3.self,
                                                   willMigrate: nil,
                                                   didMigrate: { context in
    let bookingEntries = try? context.fetch(FetchDescriptor<BookingSchemaV3.BookingEntry>())

    bookingEntries?.forEach { bookingEntry in
      bookingEntry.bookingType = bookingEntry.amountPrefix.rawValue
    }
  })

  static let migrateV3ToV4 = MigrationStage.lightweight(fromVersion: BookingSchemaV3.self, toVersion: BookingSchemaV4.self)

}
