// Created for BookingSense on 03.05.24 by kenny
// Using Swift 5.0

import XCTest

final class EmptyNavigationStackUITest: XCTestCase {

  var app: XCUIApplication!

  func localized(_ key: String) -> String {
    let uiTestBundle = Bundle(for: BasicStatsUITests.self)
    return NSLocalizedString(key, bundle: uiTestBundle, comment: "")
  }

  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments =  ["enable-testing-empty"]
    app.launch()
  }

  override func tearDownWithError() throws {
    app.terminate()
  }

  func testNavigationStackViewIsVisibleWhenOnBookingsView() throws {
    navigateToEntryNavigation()

    let addButton = app.buttons[localized("Add item")]
    let sortButton = app.buttons[localized("Sort")]
    let editButton = app.buttons[localized("Edit")]

    let entries = app.staticTexts[localized("Entries")]
    let searchField = app.searchFields[localized("Search")]

    let noEntriesText = app.staticTexts[localized("No entries available")]
    let pressButtonText = app.staticTexts[localized("Press the + button to add an entry")]

    XCTAssertTrue(addButton.isHittable)
    XCTAssertTrue(sortButton.isHittable)
    XCTAssertTrue(editButton.isHittable)
    XCTAssertTrue(entries.isHittable)
    XCTAssertTrue(searchField.isHittable)
    XCTAssertTrue(noEntriesText.isHittable)
    XCTAssertTrue(pressButtonText.isHittable)
  }

  func testNavigationStackViewIsAbleToOpenAddEntry() throws {
    navigateToEntryNavigation()
    openCreateEntrySheet(Locale.current.currency!.identifier)
  }

  func testNavigationStackViewIsAbleToAddAnEntry() throws {
    let entryName = "someEntryName"
    let entryAmount = "125"
    navigateToEntryNavigation()
    openCreateEntrySheet(Locale.current.currency!.identifier)
    addEntryInformationAndSubmit(name: entryName, amount: entryAmount)
    checkIfEntryCreated(
      Locale.current.currency!.identifier,
      name: entryName,
      amount: entryAmount
    )
  }

  func navigateToEntryNavigation() {
    XCTContext.runActivity(named: "go to entry navigation tab") { _ in
      XCTAssertTrue(app.tabBars.buttons[localized("Bookings")].isHittable)
      app.tabBars.buttons[localized("Bookings")].tap()
      XCTAssertTrue(app.tabBars.buttons[localized("Overview")].isHittable)
    }
  }

  func openCreateEntrySheet(_ localeId: String) {
    XCTContext.runActivity(named: "Open create Entry") { _ in
      let addButton = app.buttons[localized("Add item")]
      XCTAssertTrue(addButton.isHittable)
      addButton.tap()
      let navBarCreateEntry = app.navigationBars[localized("Create entry")]
      XCTAssertTrue(navBarCreateEntry.isHittable)

      let createButton = navBarCreateEntry.buttons[localized("Create")]
      let cancelButton = navBarCreateEntry.buttons[localized("Cancel")]
      let createHeadline = navBarCreateEntry.staticTexts[localized("Create entry")]

      XCTAssertTrue(cancelButton.isHittable)
      XCTAssertTrue(createButton.isHittable)
      XCTAssertTrue(createHeadline.isHittable)

      let nameTextField = app.collectionViews.textFields[localized("Name")]
      let plusPickerWheel = app.collectionViews.pickerWheels["+"]
      let amountTextField = app.collectionViews.textFields[localized("Amount")]
      let currentCurrency = app.collectionViews.staticTexts["CurrencySymbol"]
      let pickerInterval = app.collectionViews.pickers[localized("Interval")]
      let local = NSLocale(localeIdentifier: localeId)

      XCTAssertTrue(nameTextField.isHittable)
      XCTAssertTrue(plusPickerWheel.isHittable)
      XCTAssertTrue(amountTextField.isHittable)
      XCTAssertTrue(currentCurrency.isHittable)
      XCTAssertTrue(pickerInterval.isHittable)

      XCTAssertEqual(currentCurrency.label, local.displayName(forKey: NSLocale.Key.currencySymbol, value: localeId))

      let intervalButton = app.collectionViews.buttons[localized("Interval") + ", " + localized("Monthly")]
      XCTAssertTrue(intervalButton.isHittable)
    }
  }

  func addEntryInformationAndSubmit(name: String, amount: String) {
    XCTContext.runActivity(named: "enter Entry information") { _ in
      let navBarCreateEntry = app.navigationBars[localized("Create entry")]
      let createButton = navBarCreateEntry.buttons[localized("Create")]

      let nameTextField = app.collectionViews.textFields[localized("Name")]
      nameTextField.tap()
      nameTextField.typeText(name)
      let amountTextField = app.collectionViews.textFields[localized("Amount")]
      amountTextField.tap()
      amountTextField.typeText(amount)
      createButton.tap()
    }
  }

  func checkIfEntryCreated(_ localeId: String, name: String, amount: String) {
    XCTContext.runActivity(named: "check Bookings List for entry") { _ in
      let listEntry = app.collectionViews.buttons[name + amount]

      XCTAssertTrue(listEntry.isHittable)
      XCTAssertTrue(listEntry.staticTexts[name].isHittable)
      XCTAssertTrue(listEntry
        .staticTexts[TestHelper.generateFormattedCurrencyFor(localeId, number: Decimal(string: amount)!)].isHittable
      )
    }
  }
}
