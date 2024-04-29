//
//  ExpenseEntryTests.swift
//  ExpenseSenseTests
//
//  Created by Kenny Salazar on 28.04.24.
//

import XCTest
import SwiftData
@testable import ExpenseSense

final class ExpenseEntryTests: XCTestCase {

  private var context: ModelContext!

  @MainActor
  override func setUp() {
    context = mockContainer.mainContext
  }

  func testExpenseEntryCreation() throws {
    let entry = ExpenseEntry(name: "someString", amount: Decimal(), amountPrefix: .minus, interval: .annually)

    XCTAssertNotNil(entry.id)
    XCTAssertEqual(entry.name, "someString")
    XCTAssertEqual(entry.amount, 0)
    XCTAssertEqual(entry.amountPrefix, .minus)
    XCTAssertEqual(entry.interval, "annually")
  }

  func testExpenseEntryPredicate() throws {
    let predicate = ExpenseEntry.predicate(searchName: "", interval: .annually)

    XCTAssertNotNil(predicate)
  }

  func testExpenseEntryFromDecoder() throws {
    let objectString = """
    {
      "name" : "someString",
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

    let entry = try jsonDecoder.decode(ExpenseEntry.self, from: objectString)

    XCTAssertEqual(entry.id, "CDE289A7-6293-4792-A57B-A4950D8E1C11")
    XCTAssertEqual(entry.name, "someString")
    XCTAssertEqual(entry.amount, 0)
    XCTAssertEqual(entry.amountPrefix, .minus)
    XCTAssertEqual(entry.interval, "jährlich")
  }

  func testExpenseEntryEncode() throws {
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    let entry = ExpenseEntry(name: "someString", amount: Decimal(), amountPrefix: .minus, interval: .annually)
    let data = try jsonEncoder.encode(entry)
    print(String(data: data, encoding: .utf8)!)

    XCTAssertNotNil(data)
  }

  func testTotalExpenseEntries() {
    let entry = ExpenseEntry(name: "someEntry",
                             amount: Decimal(500),
                             amountPrefix: AmountPrefix.minus,
                             interval: Interval.annually)
    let entry2 = ExpenseEntry(name: "someEntry",
                             amount: Decimal(200),
                             amountPrefix: AmountPrefix.minus,
                             interval: Interval.annually)
    context.insert(entry)
    context.insert(entry2)

    let totalEntries = ExpenseEntry.totalExpenseEntries(modelContext: context)

    XCTAssertEqual(totalEntries, 2)

  }

}
