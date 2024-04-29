//
//  IntervalTests.swift
//  ExpenseSenseTests
//
//  Created by Kenny Salazar on 28.04.24.
//

import XCTest
@testable import ExpenseSense

final class IntervalTests: XCTestCase {

  func testIntervalDaily() throws {
    let interval = Interval(rawValue: "daily")
    XCTAssertNotNil(interval?.id)
    XCTAssertEqual(interval?.description, Interval.daily.description)
  }

  func testIntervalWeekly() throws {
    let interval = Interval(rawValue: "weekly")
    XCTAssertNotNil(interval?.id)
    XCTAssertEqual(interval?.description, Interval.weekly.description)
  }

  func testIntervalBiweekly() throws {
    let interval = Interval(rawValue: "biweekly")
    XCTAssertNotNil(interval?.id)
    XCTAssertEqual(interval?.description, Interval.biweekly.description)
  }

  func testIntervalMonthly() throws {
    let interval = Interval(rawValue: "monthly")
    XCTAssertNotNil(interval?.id)
    XCTAssertEqual(interval?.description, Interval.monthly.description)
  }

  func testIntervalQuarterly() throws {
    let interval = Interval(rawValue: "quarterly")
    XCTAssertNotNil(interval?.id)
    XCTAssertEqual(interval?.description, Interval.quarterly.description)
  }

  func testIntervalSemiannually() throws {
    let interval = Interval(rawValue: "semiannually")
    XCTAssertNotNil(interval?.id)
    XCTAssertEqual(interval?.description, Interval.semiannually.description)
  }

  func testIntervalAnnually() throws {
    let interval = Interval(rawValue: "annually")
    XCTAssertNotNil(interval?.id)
    XCTAssertEqual(interval?.description, Interval.annually.description)
  }

}
