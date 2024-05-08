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

    tHelp = TestHelper(FilledNavigationStackUITest.self, app: app)
  }

  override func tearDownWithError() throws {
    app.terminate()
  }

  func testNavigationStackViewShowsSavedBookings() throws {
    let names = [ "Salary", "Rent", "Car"]

    tHelp.navigateToEntryNavigation()
    for (index, name) in names.enumerated() {
      tHelp.checkIfEntryExistsWith(
        Locale.current.currency!.identifier,
        name: name,
        amount: index == 0 ? "1000" : "100"
      )
    }
  }

  func testSavedBookingsDeleteAllButton() throws {
    let names = [ "Salary", "Rent", "Car"]

    tHelp.navigateToEntryNavigation()
    tHelp.goIntoEditMode()
    for name in names {
      tHelp.checkIfEntryHasDeleteButton(name)
    }
    tHelp.openDeleteAllConfirmationScreen()
    tHelp.confirmDeleteAllConfirmationScreen()
    for name in names {
      tHelp.checkIfEntryExists(name)
    }
  }

  func testEditBookingsEntry() throws {
    tHelp.navigateToEntryNavigation()
    tHelp.openEditEntrySheet(Locale.current.currency!.identifier, name: "Salary", amount: Decimal(1000))
    app.navigationBars[tHelp.localized("Edit entry")].buttons[tHelp.localized("Entries")].tap()
    tHelp.checkIfEntryExistsWith(Locale.current.currency!.identifier, name: "Salary", amount: "1000")
  }

  func testEditBookingsEntrySavedCorrectly() throws {
    tHelp.navigateToEntryNavigation()
    tHelp.openEditEntrySheet(Locale.current.currency!.identifier, name: "Salary", amount: Decimal(1000))
    tHelp.editEntrySheetAndSave(Locale.current.currency!.identifier, newName: "newSalary", newAmount: "1100")
    tHelp.checkIfEntryExistsWith(Locale.current.currency!.identifier, name: "newSalary", amount: "1100")
  }
}
