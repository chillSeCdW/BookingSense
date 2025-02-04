//
//  ContainerFactory.swift
//  BookingSense
//
//  Created by kenny on 29.04.24.
//

import SwiftUI
import SwiftData

public typealias BookingEntry = BookingSchemaV5.BookingEntry
public typealias Tag = BookingSchemaV5.Tag
public typealias TimelineEntry = BookingSchemaV5.TimelineEntry

public struct ContainerFactory {
  public let container: ModelContainer

  public init(
    _ versionedSchema: any VersionedSchema.Type,
    storeInMemory: Bool,
    migrationPlan: SchemaMigrationPlan.Type? = nil
  ) {
    let schema = Schema(versionedSchema: versionedSchema)
    let config = ModelConfiguration(schema: schema,
                                    isStoredInMemoryOnly: storeInMemory,
                                    groupContainer: .identifier("group.com.chill.BookingSense"),
                                    cloudKitDatabase: .private("iCloud.com.chill.BookingSense-01")
    )
    do {
      container = try ModelContainer(for: schema, migrationPlan: migrationPlan, configurations: config)
    } catch {
      print(error)
      fatalError("Could not create preview container")
    }
  }

  @MainActor public static func addExamples(_ examples: [any PersistentModel], modelContext: ModelContext) {
    try? modelContext.transaction {
      examples.forEach { example in
        modelContext.insert(example)
      }
    }
  }

  public static func generateRandomEntriesItems() -> [BookingEntry] {
    var returnResult: [BookingEntry] = []
    let names = [ "Rent", "Car", "Groceries", "Gym", "Internet", "Netflix", "Donations", "Phone", "Cloud" ]

    for _ in 1...25 {
      let randomIndex = Int.random(in: 0..<names.count)
      let randomTask = names[randomIndex]

      returnResult.append(BookingEntry(name: randomTask,
                                       amount: Decimal(Double.random(in: 0...500)),
                                       bookingType: BookingType.allCases.randomElement()!.rawValue,
                                       interval: Interval.allCases.randomElement()!,
                                       tag: nil,
                                       timelineEntries: nil)
      )
    }
    return returnResult
  }

  // swiftlint:disable function_body_length
  public static func generateFixedEntriesItems() -> [BookingEntry] {
    var returnResult: [BookingEntry] = []
    let someTag: Tag = Tag(name: "someTag")

    returnResult.append(BookingEntry(name: "Trinkgeld",
                                     amount: 1,
                                     bookingType: BookingType.plus.rawValue,
                                     interval: .daily,
                                     tag: someTag,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Cashback",
                                     amount: 10,
                                     bookingType: BookingType.plus.rawValue,
                                     interval: .weekly,
                                     tag: someTag,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Tutoring",
                                     amount: 50,
                                     bookingType: BookingType.plus.rawValue,
                                     interval: .biweekly,
                                     tag: someTag,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Salary",
                                     amount: 2500,
                                     bookingType: BookingType.plus.rawValue,
                                     interval: .monthly,
                                     tag: someTag,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Rent Parking",
                                     amount: 150,
                                     bookingType: BookingType.plus.rawValue,
                                     interval: .monthly,
                                     tag: someTag,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Investment",
                                     amount: 500,
                                     bookingType: BookingType.plus.rawValue,
                                     interval: .semiannually,
                                     tag: someTag,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Festgeld",
                                     amount: 1000,
                                     bookingType: BookingType.plus.rawValue,
                                     interval: .annually,
                                     tag: someTag,
                                     timelineEntries: nil))

    returnResult.append(BookingEntry(name: "Brötchen",
                                     amount: 2.5,
                                     bookingType: BookingType.minus.rawValue,
                                     interval: .daily,
                                     tag: someTag,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Taschengeld Kinder",
                                     amount: 10,
                                     bookingType: BookingType.minus.rawValue,
                                     interval: .weekly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Babysitter",
                                     amount: 50,
                                     bookingType: BookingType.minus.rawValue,
                                     interval: .biweekly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Rent",
                                     amount: 800,
                                     bookingType: BookingType.minus.rawValue,
                                     interval: .monthly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Netflix",
                                     amount: 20,
                                     bookingType: BookingType.minus.rawValue,
                                     interval: .monthly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Benzin",
                                     amount: 150,
                                     bookingType: BookingType.minus.rawValue,
                                     interval: .monthly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Youtube Premium",
                                     amount: 14,
                                     bookingType: BookingType.minus.rawValue,
                                     interval: .monthly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "iCloud",
                                     amount: 2,
                                     bookingType: BookingType.minus.rawValue,
                                     interval: .monthly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "GEZ",
                                     amount: 55,
                                     bookingType: BookingType.minus.rawValue,
                                     interval: .quarterly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "semiannuallyEntry",
                                     amount: 200,
                                     bookingType: BookingType.minus.rawValue,
                                     interval: .semiannually,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "KFZ Steuer",
                                     amount: 450,
                                     bookingType: BookingType.minus.rawValue,
                                     interval: .annually,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "TÜV",
                                     amount: 800,
                                     bookingType: BookingType.minus.rawValue,
                                     interval: .annually,
                                     tag: nil,
                                     timelineEntries: nil))

    returnResult.append(BookingEntry(name: "Einkauf Aufrundung",
                                     amount: 1,
                                     bookingType: BookingType.saving.rawValue,
                                     interval: .daily,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Bike saving",
                                     amount: 10,
                                     bookingType: BookingType.saving.rawValue,
                                     interval: .weekly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Phone saving",
                                     amount: 20,
                                     bookingType: BookingType.saving.rawValue,
                                     interval: .biweekly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Tagesgeld",
                                     amount: 500,
                                     bookingType: BookingType.saving.rawValue,
                                     interval: .monthly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "ETF",
                                     amount: 200,
                                     bookingType: BookingType.saving.rawValue,
                                     interval: .monthly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Versicherung",
                                     amount: 200,
                                     bookingType: BookingType.saving.rawValue,
                                     interval: .quarterly,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Altervorsorge",
                                     amount: 200,
                                     bookingType: BookingType.saving.rawValue,
                                     interval: .semiannually,
                                     tag: nil,
                                     timelineEntries: nil))
    returnResult.append(BookingEntry(name: "Auto reperatur",
                                     amount: 500,
                                     bookingType: BookingType.saving.rawValue,
                                     interval: .annually,
                                     tag: nil,
                                     timelineEntries: nil))
    return returnResult
  }
  // swiftlint:enable function_body_length
}
