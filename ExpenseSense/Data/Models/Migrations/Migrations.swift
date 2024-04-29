//
//  Migrations.swift
//  ExpenseSense
//
//  Created by Kenny Salazar on 29.04.24.
//

import Foundation
import SwiftData

enum ExpenseMigrationV1ToV2: SchemaMigrationPlan {
  static var schemas: [any VersionedSchema.Type] {
    [
      ExpenseSchemaV1.self
    ]
  }

  static var stages: [MigrationStage] {
    [

    ]
  }
}
