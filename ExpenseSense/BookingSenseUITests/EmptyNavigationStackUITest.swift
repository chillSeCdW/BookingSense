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

    tHelp = TestHelper(EmptyNavigationStackUITest.self)
  }

  override func tearDownWithError() throws {
    app.terminate()
  }

  func testNavigationStackViewIsVisibleWhenOnBookingsView() throws {
    navigateToEntryNavigation()

    let addButton = app.buttons[tHelp.localized("Add item")]
    let sortButton = app.buttons[tHelp.localized("Sort")]
    let editButton = app.buttons[tHelp.localized("Edit")]

    let entries = app.staticTexts[tHelp.localized("Entries")]
    let searchField = app.searchFields[tHelp.localized("Search")]

    let noEntriesText = app.staticTexts[tHelp.localized("No entries available")]
    let pressButtonText = app.staticTexts[tHelp.localized("Press the + button to add an entry")]

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
      XCTAssertTrue(app.tabBars.buttons[tHelp.localized("Bookings")].isHittable)
      app.tabBars.buttons[tHelp.localized("Bookings")].tap()
      XCTAssertTrue(app.tabBars.buttons[tHelp.localized("Overview")].isHittable)
    }
  }

  func openCreateEntrySheet(_ localeId: String) {
    XCTContext.runActivity(named: "Open create Entry") { _ in
      let addButton = app.buttons[tHelp.localized("Add item")]
      XCTAssertTrue(addButton.isHittable)
      addButton.tap()
      let navBarCreateEntry = app.navigationBars[tHelp.localized("Create entry")]
      XCTAssertTrue(navBarCreateEntry.isHittable)

      let createButton = navBarCreateEntry.buttons[tHelp.localized("Create")]
      let cancelButton = navBarCreateEntry.buttons[tHelp.localized("Cancel")]
      let createHeadline = navBarCreateEntry.staticTexts[tHelp.localized("Create entry")]

      XCTAssertTrue(cancelButton.isHittable)
      XCTAssertTrue(createButton.isHittable)
      XCTAssertTrue(createHeadline.isHittable)

      let nameTextField = app.collectionViews.textFields[tHelp.localized("Name")]
      let plusPickerWheel = app.collectionViews.pickerWheels["+"]
      let amountTextField = app.collectionViews.textFields[tHelp.localized("Amount")]
      let currentCurrency = app.collectionViews.staticTexts["CurrencySymbol"]
      let pickerInterval = app.collectionViews.pickers[tHelp.localized("Interval")]
      let local = NSLocale(localeIdentifier: localeId)

      XCTAssertTrue(nameTextField.isHittable)
      XCTAssertTrue(plusPickerWheel.isHittable)
      XCTAssertTrue(amountTextField.isHittable)
      XCTAssertTrue(currentCurrency.isHittable)
      XCTAssertTrue(pickerInterval.isHittable)

      XCTAssertEqual(currentCurrency.label, local.displayName(forKey: NSLocale.Key.currencySymbol, value: localeId))

      let intervalButton = app.collectionViews.buttons[tHelp.localized("Interval") + ", " + tHelp.localized("Monthly")]
      XCTAssertTrue(intervalButton.isHittable)
    }
  }

  func addEntryInformationAndSubmit(name: String, amount: String) {
    XCTContext.runActivity(named: "enter Entry information") { _ in
      let navBarCreateEntry = app.navigationBars[tHelp.localized("Create entry")]
      let createButton = navBarCreateEntry.buttons[tHelp.localized("Create")]

      let nameTextField = app.collectionViews.textFields[tHelp.localized("Name")]
      nameTextField.tap()
      nameTextField.typeText(name)
      let amountTextField = app.collectionViews.textFields[tHelp.localized("Amount")]
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
        .staticTexts[tHelp.generateFormattedCurrencyFor(localeId, number: Decimal(string: amount)!)].isHittable
      )
    }
  }
}
