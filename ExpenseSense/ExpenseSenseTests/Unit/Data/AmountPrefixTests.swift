//
//  AmountPrefixTests.swift
//  ExpenseSenseTests
//
//  Created by Kenny Salazar on 28.04.24.
//

import XCTest
@testable import ExpenseSense

final class AmountPrefixTests: XCTestCase {

  func testAmountPrefixMinus() throws {
    let amountPreMinus = AmountPrefix.minus

    XCTAssertNotNil(amountPreMinus.id)
    XCTAssertEqual(amountPreMinus.description, AmountPrefix.minus.description)
  }

  func testAmountPrefixPlus() throws {
    let amountPrePlus = AmountPrefix.plus

    XCTAssertNotNil(amountPrePlus.id)
    XCTAssertEqual(amountPrePlus.description, AmountPrefix.plus.description)
  }

}
