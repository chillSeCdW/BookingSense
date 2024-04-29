//
//  Constants.swift
//  ExpenseSenseTests
//
//  Created by Kenny Salazar on 27.04.24.
//

import XCTest
import SwiftUI

@testable import ExpenseSense
import SwiftData

final class ConstantsTests: XCTestCase {

  func testListBackgroundColors() throws {
    XCTAssertEqual(
      Constants.listBackgroundColors[AmountPrefix.plus],
      Color(UIColor(red: 0.2039, green: 0.7373, blue: 0.2039, alpha: 1.0))

    )
    XCTAssertEqual(
      Constants.listBackgroundColors[AmountPrefix.minus],
      Color(UIColor(red: 0.7882, green: 0, blue: 0.0118, alpha: 1.0))
    )
  }

  func testGetBackground() throws {
    XCTAssertEqual(
      Constants.getBackground(ColorScheme.dark),
      Color(uiColor: UIColor(white: 1, alpha: 0.15))
    )
    XCTAssertEqual(
      Constants.getBackground(ColorScheme.light),
      .white
    )
  }

  func testCreateDescriptor() throws {
    let searchString = ""
    let interval = Interval.annually

    XCTAssertNotNil(Constants.createDescriptor(searchString: searchString, interval: interval))
  }

  func testGetSymbol() throws {
    let code = "plus"

    XCTAssertEqual(
      Constants.getSymbol(code),
      NSLocale(localeIdentifier: code).displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    )
  }

  func testCreateToast() throws {
    XCTAssertEqual(
      Constants.createToast(.info, message: "someMessage"),
      Toast(style: .info, title: String(localized: "Info"), message: "someMessage", duration: 10, width: 160)
    )
    XCTAssertEqual(
      Constants.createToast(.error, message: "someError"),
      Toast(style: .error, title: String(localized: "Error"), message: "someError", duration: 10, width: 160)
    )
  }
}
