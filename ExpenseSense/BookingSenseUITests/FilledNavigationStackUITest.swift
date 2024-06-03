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

    let entries = [
      "dailyEntry": "1",
      "weeklyEntry": "10",
      "someSecondSalary": "150",
      "biweeklyEntry": "20",
      "monthlyEntry": "800",
      "Salary": "2500",
      "quarterlyEntry": "100",
      "semiannuallyEntry": "200",
      "annuallyEntry": "400"
    ]

    tHelp.navigateToEntryNavigation()
    for (name, amount) in entries {
      tHelp.checkIfEntryExistsWith(
        Locale.current.currency!.identifier,
        name: name,
        amount: amount
      )
    }
  }

  func testSavedBookingsDeleteAllButton() throws {
    let entries = [
      "dailyEntry": "1",
      "weeklyEntry": "10",
      "someSecondSalary": "150",
      "biweeklyEntry": "20",
      "monthlyEntry": "800",
      "Salary": "2500",
      "quarterlyEntry": "100",
      "semiannuallyEntry": "200",
      "annuallyEntry": "400"
    ]

    tHelp.navigateToEntryNavigation()
    tHelp.goIntoEditMode()
    for (name, _) in entries {
      tHelp.checkIfEntryHasDeleteButton(name)
    }
    tHelp.openDeleteAllConfirmationScreen()
    tHelp.confirmDeleteAllConfirmationScreen()
    for (name, _) in entries {
      tHelp.checkIfEntryExists(name)
    }
  }

  func testEditBookingsEntry() throws {
    tHelp.navigateToEntryNavigation()
    tHelp.openEditEntrySheet(Locale.current.currency!.identifier, name: "Salary", amount: Decimal(2500))
    app.navigationBars[tHelp.localized("Edit entry")].buttons[tHelp.localized("Bookings")].tap()
    tHelp.checkIfEntryExistsWith(Locale.current.currency!.identifier, name: "Salary", amount: "2500")
  }

  func testEditBookingsEntrySavedCorrectly() throws {
    tHelp.navigateToEntryNavigation()
    tHelp.openEditEntrySheet(Locale.current.currency!.identifier, name: "Salary", amount: Decimal(2500))
    tHelp.editEntrySheetAndSave(Locale.current.currency!.identifier, newName: "newSalary", newAmount: "1100")
    tHelp.checkIfEntryExistsWith(Locale.current.currency!.identifier, name: "newSalary", amount: "1100")
  }

  func testDeleteBookingsEntry() throws {
    tHelp.navigateToEntryNavigation()
    tHelp.deleteEntry(name: "Salary")
    tHelp.checkIfEntryExists("Salary")
  }

  func testEditBookingsEntryTriggersToast() throws {
    let newAmount = "11" + Locale.current.decimalSeparator! + Locale.current.decimalSeparator! + "00"
    tHelp.navigateToEntryNavigation()
    tHelp.openEditEntrySheet(Locale.current.currency!.identifier, name: "Salary", amount: Decimal(2500))
    tHelp.editEntrySheetAndSave(Locale.current.currency!.identifier, newName: "newSalary", newAmount: newAmount)
    tHelp.checkIfEntryExistsWith(Locale.current.currency!.identifier, name: "newSalary", amount: "11")
    tHelp.checkIfToastExistsWith(amount: "11")
    tHelp.dismissToast()
  }
}
