//
//  BasicStatsUITests.swift
//  ExpenseSenseTests
//
//  Created by Kenny Salazar on 28.04.24.
//

import XCTest

 final class BasicStatsUITests: XCTestCase {

  var app: XCUIApplication!

  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments =  ["enable-testing"]
    app.launch()
  }

  override func tearDownWithError() throws {
    app.terminate()
  }

  func testBasicStatsAreVisibleWhenOnOverview() throws {
    XCTAssertTrue(app.tabBars.buttons["Übersicht"].isHittable)
    app.tabBars.buttons["Übersicht"].tap()
    let income = app.staticTexts["Gesamtes Einkommen:"]
    let deductions = app.staticTexts["Gesamte Abzüge:"]
    let plus = app.staticTexts["12.000,00 €"]
    let minus = app.staticTexts["2.400,00 €"]

    XCTAssertTrue(income.isHittable)
    XCTAssertTrue(deductions.isHittable)
    XCTAssertTrue(plus.exists)
    XCTAssertTrue(minus.exists)
  }
 }
