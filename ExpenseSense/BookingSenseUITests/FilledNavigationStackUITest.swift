// Created for BookingSense on 03.05.24 by kenny
// Using Swift 5.0

import XCTest

final class FilledNavigationStackUITest: XCTestCase {

  var app: XCUIApplication!
  var tHelp: TestHelper!

  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments =  ["enable-testing-data"]
    app.launch()

    tHelp = TestHelper(FilledNavigationStackUITest.self)
  }

  override func tearDownWithError() throws {
    app.terminate()
  }

  func testNavigationStackViewIsVisibleWhenOnBookingsView() throws {
    XCTAssertTrue(app.tabBars.buttons[tHelp.localized("Bookings")].isHittable)
    app.tabBars.buttons[tHelp.localized("Bookings")].tap()
    XCTAssertTrue(app.tabBars.buttons[tHelp.localized("Overview")].isHittable)

    let addButton = app.buttons[tHelp.localized("Add item")]
    let sortButton = app.buttons[tHelp.localized("Sort")]
    let editButton = app.buttons[tHelp.localized("Edit")]

    let entries = app.staticTexts[tHelp.localized("Entries")]
    let searchField = app.searchFields[tHelp.localized("Search")]

    XCTAssertTrue(addButton.isHittable)
    XCTAssertTrue(sortButton.isHittable)
    XCTAssertTrue(editButton.isHittable)
    XCTAssertTrue(entries.isHittable)
    XCTAssertTrue(searchField.isHittable)
  }
}
