// Created for BookingSense on 03.05.24 by kenny
// Using Swift 5.0

import XCTest

final class FilledNavigationStackUITest: XCTestCase {

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

  func testNavigationStackViewIsVisibleWhenOnBookingsView() throws {
    XCTAssertTrue(app.tabBars.buttons[localized("Bookings")].isHittable)
    app.tabBars.buttons[localized("Bookings")].tap()
    XCTAssertTrue(app.tabBars.buttons[localized("Overview")].isHittable)

    let addButton = app.buttons[localized("Add item")]
    let sortButton = app.buttons[localized("Sort")]
    let editButton = app.buttons[localized("Edit")]

    let entries = app.staticTexts[localized("Entries")]
    let searchField = app.searchFields[localized("Search")]

    XCTAssertTrue(addButton.isHittable)
    XCTAssertTrue(sortButton.isHittable)
    XCTAssertTrue(editButton.isHittable)
    XCTAssertTrue(entries.isHittable)
    XCTAssertTrue(searchField.isHittable)
  }
}
