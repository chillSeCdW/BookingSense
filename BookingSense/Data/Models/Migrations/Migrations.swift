//
//  Migrations.swift
//  BookingSense
//
//  Created by kenny on 29.04.24.
//

import Foundation
import SwiftData

enum ExpenseMigrationV1ToV2: SchemaMigrationPlan {
  static var schemas: [any VersionedSchema.Type] {
    [
      BookingSchemaV1.self,
      BookingSchemaV2.self
    ]
  }

  static var stages: [MigrationStage] {
    [
      migrateV1ToV2
    ]
  }

  static let migrateV1ToV2 = MigrationStage.lightweight(
    fromVersion: BookingSchemaV1.self,
    toVersion: BookingSchemaV2.self
  )

}
