// Created for BookingSense on 03.05.24 by kenny
// Using Swift 5.0

import XCTest

final class EmptyNavigationStackUITest: XCTestCase {

  var app: XCUIApplication!
  var tHelp: TestHelper!

  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments =  ["enable-testing-empty"]
    app.launch()

    tHelp = TestHelper(EmptyNavigationStackUITest.self, app: app)
  }

  override func tearDownWithError() throws {
    app.terminate()
  }

  func testNavigationStackViewIsVisibleWhenOnBookingsView() throws {
    tHelp.navigateToEntryNavigation()

    let addButton = app.buttons[tHelp.localized("Add item")]
    let sortButton = app.buttons[tHelp.localized("Sort")]
    let editButton = app.buttons[tHelp.localized("Edit")]

    let bookings = app.staticTexts[tHelp.localized("Bookings")]
    let searchField = app.searchFields[tHelp.localized("Search")]

    let noEntriesText = app.staticTexts[tHelp.localized("No entries available")]
    let pressButtonText = app.staticTexts[tHelp.localized("Press the + button to add an entry")]

    XCTAssertTrue(addButton.isHittable)
    XCTAssertTrue(sortButton.isHittable)
    XCTAssertTrue(editButton.isHittable)
    XCTAssertTrue(bookings.isHittable)
    XCTAssertTrue(searchField.isHittable)
    XCTAssertTrue(noEntriesText.isHittable)
    XCTAssertTrue(pressButtonText.isHittable)
  }

  func testNavigationStackViewIsAbleToOpenAddEntry() throws {
    tHelp.navigateToEntryNavigation()
    tHelp.openCreateEntrySheet(Locale.current.currency!.identifier)
  }

  func testNavigationStackViewIsAbleToAddAnEntry() throws {
    let entryName = "someEntryName"
    let entryAmount = "125"
    tHelp.navigateToEntryNavigation()
    tHelp.openCreateEntrySheet(Locale.current.currency!.identifier)
    tHelp.addEntryInformationAndSubmit(name: entryName, amount: entryAmount)
    tHelp.checkIfEntryExistsWith(
      Locale.current.currency!.identifier,
      name: entryName,
      amount: entryAmount
    )
  }

  func testNavigationStackViewIsAbleToAddAnPastedEntryWithSign() throws {
    let entryName = "someEntryName"
    let entryAmount = "-125"
    tHelp.navigateToEntryNavigation()
    tHelp.openCreateEntrySheet(Locale.current.currency!.identifier)
    tHelp.addEntryInformationAndSubmit(name: entryName, amount: entryAmount)
    tHelp.checkIfEntryExistsWith(
      Locale.current.currency!.identifier,
      name: entryName,
      amount: "125"
    )
  }
}
