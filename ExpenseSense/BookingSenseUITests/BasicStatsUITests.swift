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
    app.launchArguments =  ["enable-testing"]
    app.launch()
  }

  override func tearDownWithError() throws {
    app.terminate()
  }

  func testBasicStatsAreVisibleWhenOnOverview() throws {
    XCTAssertTrue(app.tabBars.buttons[localized("Overview")].isHittable)
    app.tabBars.buttons[localized("Overview")].tap()
    let income = app.staticTexts[localized("Your Total plus:")]
    let deductions = app.staticTexts[localized("Your Total minus:")]
//    let plus = app.staticTexts["12.000,00 €"]
//    let minus = app.staticTexts["2.400,00 €"]

    XCTAssertTrue(income.isHittable)
    XCTAssertTrue(deductions.isHittable)
//    XCTAssertTrue(plus.exists)
//    XCTAssertTrue(minus.exists)
  }
}
