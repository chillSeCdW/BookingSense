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

  func generateFormattedCurrencyStringFromCurrentLocaleFor(_ number: Decimal) -> String {
    generateFormattedCurrencyFor(Locale.current.currency!.identifier, number: number)
  }

  func generateFormattedStringFromFormatterFor(_ number: Decimal) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.usesGroupingSeparator = false

    return formatter.string(from: NSDecimalNumber(decimal: number))!
  }

  func navigateToEntryNavigation() {
    XCTContext.runActivity(named: "go to entry navigation tab") { _ in
      XCTAssertTrue(app.tabBars.buttons[localized("Bookings")].isHittable)
      app.tabBars.buttons[localized("Bookings")].tap()
      XCTAssertTrue(app.tabBars.buttons[localized("Overview")].isHittable)
    }
  }

  func openEditEntrySheet(_ localeId: String, name: String, amount: Decimal) {
    XCTContext.runActivity(named: "Open edit Entry") { _ in
      let listEntry = app.collectionViews.buttons["NavLink" + name]
      XCTAssertTrue(listEntry.isHittable)
      listEntry.tap()
      let navBarEditEntry = app.navigationBars[localized("Edit entry")]
      XCTAssertTrue(navBarEditEntry.isHittable)

      let backButton = navBarEditEntry.buttons[localized("Bookings")]
      let saveButton = navBarEditEntry.buttons[localized("Save")]
      let createHeadline = navBarEditEntry.staticTexts[localized("Edit entry")]

      XCTAssertTrue(backButton.isHittable)
      XCTAssertTrue(saveButton.isHittable)
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

      XCTAssertEqual(nameTextField.value as? String, name)
      XCTAssertEqual(amountPrefixPicker.pickerWheels.element.value as? String, "+")
      XCTAssertEqual(amountTextField.value as? String, generateFormattedStringFromFormatterFor(amount))
      XCTAssertEqual(currentCurrency.label, local.displayName(forKey: NSLocale.Key.currencySymbol, value: localeId))
      XCTAssertEqual(intervalText.label, localized("Interval"))
      XCTAssertTrue(intervalPicker.staticTexts[localized("Monthly")].isHittable)

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

  func deleteEntry(name: String) {
    XCTContext.runActivity(named: "delete Entry with values") { _ in
      let listEntry = app.collectionViews.buttons["NavLink" + name]
      listEntry.swipeLeft()
      let deleteButton = app.collectionViews.buttons[localized("Delete")]
      deleteButton.tap()
    }
  }

  func editEntrySheetAndSave(_ localeId: String, newName: String, newAmount: String) {
    XCTContext.runActivity(named: "edit Entry with new values") { _ in
      let navBarEditEntry = app.navigationBars[localized("Edit entry")]
      XCTAssertTrue(navBarEditEntry.isHittable)

      let saveButton = navBarEditEntry.buttons[localized("Save")]
      XCTAssertTrue(saveButton.isHittable)

      let nameTextField = app.collectionViews.textFields[localized("Name")]
      let plusPickerWheel = app.collectionViews.pickerWheels["+"]
      let amountTextField = app.collectionViews.textFields[localized("Amount")]
      let intervalPicker = app.collectionViews.buttons["intervalPicker"]

      nameTextField.doubleTap()
      nameTextField.typeText(newName)
      amountTextField.doubleTap()
      amountTextField.typeText(newAmount)
      plusPickerWheel.adjust(toPickerWheelValue: "-")
      intervalPicker.tap()
      app.collectionViews.buttons[localized("Biweekly")].tap()

      saveButton.tap()
    }
  }

  func checkIfEntryExistsWith(_ localeId: String, name: String, amount: String) {
    XCTContext.runActivity(named: "check if entry was created with values") { _ in
      let listEntry = app.collectionViews.buttons["NavLink" + name]
      let maxSwipes = 2
      var count = 0

      while !listEntry.isHittable && count < maxSwipes {
        app.swipeUp()
        count += 1
        if !listEntry.isHittable {
          app.swipeDown()
        }
      }

      XCTAssertTrue(listEntry.isHittable)
      XCTAssertTrue(listEntry.staticTexts[name].isHittable)
      XCTAssertTrue(listEntry
        .staticTexts[generateFormattedCurrencyFor(localeId, number: Decimal(string: amount)!)].isHittable
      )
    }
  }

  func checkIfToastExistsWith(amount: String) {
    XCTContext.runActivity(named: "check if Toast was created with values") { _ in

      let image = app.images.matching(identifier: "ToastView").element

      let titleLabel = app.staticTexts.matching(identifier: "ToastView")
      .containing(XCUIElement.ElementType.staticText, identifier: localized("Info")).element.label

      let message = String.localizedStringWithFormat(localized("%@ transformedInfo"), amount)

      let messageLabel = app.staticTexts.matching(identifier: "ToastView")
        .containing(XCUIElement.ElementType.staticText, identifier: message).element.label

      let toastButton = app.buttons.matching(identifier: "ToastView").element

      XCTAssertTrue(toastButton.isHittable)
      XCTAssertTrue(image.isHittable)
      XCTAssertEqual(titleLabel, localized("Info"))
      XCTAssertEqual(messageLabel, message)

    }
  }

  func dismissToast() {
    XCTContext.runActivity(named: "dismissing Toast") { _ in
      let toastButton = app.buttons.matching(identifier: "ToastView").element

      toastButton.tap()
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
      let maxSwipes = 2
      var count = 0

      while !listEntry.isHittable && count < maxSwipes {
        app.swipeUp()
        count += 1
        if !listEntry.isHittable {
          app.swipeDown()
        }
      }

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
