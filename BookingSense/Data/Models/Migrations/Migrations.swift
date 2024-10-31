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
      BookingSchemaV3.self
    ]
  }

  static var stages: [MigrationStage] {
    [
      migrateV1ToV2,
      migrateV2ToV3
    ]
  }

  static let migrateV1ToV2 = MigrationStage.lightweight(
    fromVersion: BookingSchemaV1.self,
    toVersion: BookingSchemaV2.self
  )
  static let migrateV2ToV3 = MigrationStage.lightweight(
    fromVersion: BookingSchemaV2.self,
    toVersion: BookingSchemaV3.self
  )

}
