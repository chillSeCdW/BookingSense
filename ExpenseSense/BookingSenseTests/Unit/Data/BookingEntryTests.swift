//
//  BookingEntryTests.swift
//  BookingSenseTests
//
//  Created by kenny on 28.04.24.
//

import XCTest
import SwiftData
@testable import BookingSense

final class BookingEntryTests: XCTestCase {

  private var context: ModelContext!

  @MainActor
  override func setUp() {
    context = mockContainer.mainContext
  }

  func testExpenseEntryCreation() throws {
    let entry = BookingEntry(
      name: "someString",
      tags: ["default"],
      amount: Decimal(),
      amountPrefix: .minus,
      interval: .annually
    )

    XCTAssertNotNil(entry.id)
    XCTAssertEqual(entry.name, "someString")
    XCTAssertEqual(entry.amount, 0)
    XCTAssertEqual(entry.amountPrefix, .minus)
    XCTAssertEqual(entry.interval, "annually")
  }

  func testExpenseEntryPredicate() throws {
    let predicate = BookingEntry.predicate(searchName: "", interval: .annually)

    XCTAssertNotNil(predicate)
  }

  func testExpenseEntryFromDecoder() throws {
    let objectString = """
    {
      "name" : "someString",
      "tags" : ["default"],
      "amount" : 0,
      "id" : "CDE289A7-6293-4792-A57B-A4950D8E1C11",
      "amountPrefix" : {
        "minus" : {

        }
      },
      "interval" : "jährlich"
    }
    """.data(using: .utf8)!
    let jsonDecoder = JSONDecoder()

    let entry = try jsonDecoder.decode(BookingEntry.self, from: objectString)

    XCTAssertEqual(entry.id, "CDE289A7-6293-4792-A57B-A4950D8E1C11")
    XCTAssertEqual(entry.name, "someString")
    XCTAssertEqual(entry.tags[0], "default")
    XCTAssertEqual(entry.amount, 0)
    XCTAssertEqual(entry.amountPrefix, .minus)
    XCTAssertEqual(entry.interval, "jährlich")
  }

  func testExpenseEntryEncode() throws {
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    let entry = BookingEntry(
      name: "someString",
      tags: ["default"],
      amount: Decimal(),
      amountPrefix: .minus,
      interval: .annually
    )
    let data = try jsonEncoder.encode(entry)
    print(String(data: data, encoding: .utf8)!)

    XCTAssertNotNil(data)
  }

  func testTotalExpenseEntries() {
    let entry = BookingEntry(name: "someEntry",
                             tags: ["default"],
                             amount: Decimal(500),
                             amountPrefix: AmountPrefix.minus,
                             interval: Interval.annually)
    let entry2 = BookingEntry(name: "someEntry",
                              tags: ["default"],
                              amount: Decimal(200),
                              amountPrefix: AmountPrefix.minus,
                              interval: Interval.annually)
    context.insert(entry)
    context.insert(entry2)

    let totalEntries = BookingEntry.totalExpenseEntries(modelContext: context)

    XCTAssertEqual(totalEntries, 2)

  }

}
