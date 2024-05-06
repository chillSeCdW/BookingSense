//
//  BasicStatsUITests.swift
//  BookingSenseUITests
//
//  Created by kenny on 28.04.24.
//

import XCTest

final class BasicStatsUITests: XCTestCase {

  var app: XCUIApplication!

  func localized(_ key: String) -> String {
    let uiTestBundle = Bundle(for: BasicStatsUITests.self)
    return NSLocalizedString(key, bundle: uiTestBundle, comment: "")
  }

  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments =  ["enable-testing-data"]
    app.launch()
  }

  override func tearDownWithError() throws {
    app.terminate()
  }

  func testBasicStatsAreVisibleWhenOnOverview() throws {
    XCTAssertTrue(app.tabBars.buttons[localized("Overview")].isHittable)
    app.tabBars.buttons[localized("Overview")].tap()
    let income = app.collectionViews.staticTexts[localized("Your total plus")]
    let deductions = app.collectionViews.staticTexts[localized("Your total minus")]
    let plus = app.collectionViews.staticTexts[TestHelper.generateFormattedStringFromCurrentLocaleFor(Decimal(12000))]
    let minus = app.collectionViews.staticTexts[TestHelper.generateFormattedStringFromCurrentLocaleFor(Decimal(2400))]

    XCTAssertTrue(income.isHittable)
    XCTAssertTrue(deductions.isHittable)
    XCTAssertTrue(plus.exists)
    XCTAssertTrue(minus.exists)
  }
}
