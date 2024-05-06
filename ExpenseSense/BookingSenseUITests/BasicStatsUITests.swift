//
//  BasicStatsUITests.swift
//  BookingSenseUITests
//
//  Created by kenny on 28.04.24.
//

import XCTest

final class BasicStatsUITests: XCTestCase {

  var app: XCUIApplication!
  var tHelp: TestHelper!

  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments =  ["enable-testing-data"]
    app.launch()

    tHelp = TestHelper(BasicStatsUITests.self)
  }

  override func tearDownWithError() throws {
    app.terminate()
  }

  func testBasicStatsAreVisibleWhenOnOverview() throws {
    XCTAssertTrue(app.tabBars.buttons[tHelp.localized("Overview")].isHittable)
    app.tabBars.buttons[tHelp.localized("Overview")].tap()
    let income = app.collectionViews.staticTexts[tHelp.localized("Your total plus")]
    let deductions = app.collectionViews.staticTexts[tHelp.localized("Your total minus")]
    let plus = app.collectionViews.staticTexts[tHelp.generateFormattedStringFromCurrentLocaleFor(Decimal(12000))]
    let minus = app.collectionViews.staticTexts[tHelp.generateFormattedStringFromCurrentLocaleFor(Decimal(2400))]

    XCTAssertTrue(income.isHittable)
    XCTAssertTrue(deductions.isHittable)
    XCTAssertTrue(plus.exists)
    XCTAssertTrue(minus.exists)
  }
}
