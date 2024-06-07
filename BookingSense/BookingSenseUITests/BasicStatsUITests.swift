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

    tHelp = TestHelper(BasicStatsUITests.self, app: app)
  }

  override func tearDownWithError() throws {
    app.terminate()
  }

  func testBasicStatsAreVisibleWhenOnOverview() throws {
    XCTAssertTrue(app.tabBars.buttons[tHelp.localized("Overview")].isHittable)
    app.tabBars.buttons[tHelp.localized("Overview")].tap()
    let income = app.collectionViews.staticTexts[tHelp.localized("Your total plus")]
    let deductions = app.collectionViews.staticTexts[tHelp.localized("Your total minus")]
    let leftText = app.collectionViews.staticTexts[tHelp.localized("Your total left")]
    let numberEntries = app.collectionViews.staticTexts[tHelp.localized("Your total entries")]
    let plus = app.collectionViews
      .staticTexts[tHelp.generateFormattedCurrencyStringFromCurrentLocaleFor(Decimal(33900))]
    let minus = app.collectionViews
      .staticTexts[tHelp.generateFormattedCurrencyStringFromCurrentLocaleFor(Decimal(12205))]
    let leftNumber = app.collectionViews
      .staticTexts[tHelp.generateFormattedCurrencyStringFromCurrentLocaleFor(Decimal(21695))]
    let entriesNumber = app.collectionViews
      .staticTexts["9"]

    XCTAssertTrue(income.isHittable)
    XCTAssertTrue(deductions.isHittable)
    XCTAssertTrue(leftText.isHittable)
    XCTAssertTrue(numberEntries.isHittable)
    XCTAssertTrue(plus.exists)
    XCTAssertTrue(minus.exists)
    XCTAssertTrue(leftNumber.exists)
    XCTAssertTrue(entriesNumber.exists)
  }
}
