// Created for BookingSense on 06.05.24 by kenny
// Using Swift 5.0

import Foundation
import XCTest

class TestHelper {

  let aClass: AnyClass

  let app: XCUIApplication

  init(_ aClass: AnyClass, app: XCUIApplication) {
    self.aClass = aClass
    self.app = app
  }

  func localized(_ key: String) -> String {
    let uiTestBundle = Bundle(for: aClass)
    return NSLocalizedString(key, bundle: uiTestBundle, comment: "")
  }

  func generateFormattedCurrencyFor(_ localeId: String, number: Decimal) -> String {
    number.formatted(.currency(code: localeId))
  }

  func generateFormattedStringFromCurrentLocaleFor(_ number: Decimal) -> String {
    generateFormattedCurrencyFor(Locale.current.currency!.identifier, number: number)
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
      let amountPrefixPicker = app.collectionViews.pickers[localized("AmountPrefix")]
      let intervalPicker = app.collectionViews.buttons["intervalPicker"]
      let intervalText = app.collectionViews.staticTexts[localized("Interval")]
      let local = NSLocale(localeIdentifier: localeId)

      XCTAssertTrue(nameTextField.isHittable)
      XCTAssertTrue(plusPickerWheel.isHittable)
      XCTAssertTrue(amountTextField.isHittable)
      XCTAssertTrue(currentCurrency.isHittable)
      XCTAssertTrue(amountPrefixPicker.isHittable)
      XCTAssertTrue(intervalPicker.isHittable)

      XCTAssertEqual(nameTextField.value as? String, localized("Name"))
      XCTAssertEqual(amountPrefixPicker.pickerWheels.element.value as? String, "+")
      XCTAssertEqual(amountTextField.value as? String, localized("Amount"))
      XCTAssertEqual(currentCurrency.label, local.displayName(forKey: NSLocale.Key.currencySymbol, value: localeId))
      XCTAssertEqual(intervalText.label, localized("Interval"))
      XCTAssertTrue(intervalPicker.staticTexts[localized("Monthly")].isHittable)
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

  func checkIfEntryExistsWith(_ localeId: String, name: String, amount: String) {
    XCTContext.runActivity(named: "check if entry was created with values") { _ in
      let listEntry = app.collectionViews.buttons["NavLink" + name]

      XCTAssertTrue(listEntry.isHittable)
      XCTAssertTrue(listEntry.staticTexts[name].isHittable)
      XCTAssertTrue(listEntry
        .staticTexts[generateFormattedCurrencyFor(localeId, number: Decimal(string: amount)!)].isHittable
      )
    }
  }

  func checkIfEntryExists(_ name: String) {
    XCTContext.runActivity(named: "check if entry exists") { _ in
      let waiter = XCTWaiter()
      let result = waiter.wait(for: [
        XCTNSPredicateExpectation(
          predicate: NSPredicate(format: "exists == 0"),
          object: app.collectionViews.buttons["NavLink" + name])
      ], timeout: 2)

      switch result {
      case .timedOut:
          XCTFail("Element still exists after timeout")
      default:
          break
      }
    }
  }

  func checkIfEntriesListIsEmpty() {
    XCTContext.runActivity(named: "check if entry exists") { _ in
      XCTAssertEqual(app.collectionViews.buttons.count, 0)
    }
  }

  func checkIfEntryHasDeleteButton(_ name: String) {
    XCTContext.runActivity(named: "checking if Entry has delete button") { _ in
      let listEntry = app.collectionViews.buttons["NavLink" + name]

      XCTAssertTrue(listEntry.isHittable)
      XCTAssertTrue(listEntry.images.element.exists)
    }
  }

  func goIntoEditMode() {
    XCTContext.runActivity(named: "activate edit mode") { _ in
      app.navigationBars.buttons[localized("Edit")].tap()
      let deleteAllButton = app.navigationBars.buttons[localized("Delete all")]
      XCTAssertTrue(deleteAllButton.isHittable)
    }
  }

  func openDeleteAllConfirmationScreen() {
    XCTContext.runActivity(named: "open Delete all confirmation screen") { _ in
      app.navigationBars.buttons[localized("Delete all")].tap()
      let staticDeleteAllText = app.scrollViews.element(boundBy: 0)
        .staticTexts[localized("Are you sure you want to delete all entries?")]
      let deleteAllConfirm = app.scrollViews.element(boundBy: 1)
        .buttons[localized("Delete all entries")]
      let deleteAllCancel = app.scrollViews.element(boundBy: 2)
        .buttons[localized("Cancel")]

      XCTAssertEqual(staticDeleteAllText.label, localized("Are you sure you want to delete all entries?"))
      XCTAssertEqual(deleteAllConfirm.label, localized("Delete all entries"))
      XCTAssertEqual(deleteAllCancel.label, localized("Cancel"))
    }
  }

  func confirmDeleteAllConfirmationScreen() {
    XCTContext.runActivity(named: "confirm Delete all confirmation screen") { _ in
      app.scrollViews.element(boundBy: 1).buttons[localized("Delete all entries")].tap()
    }
  }
}
