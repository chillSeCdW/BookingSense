//
//  Constants.swift
//  BookingSenseTests
//
//  Created by kenny on 27.04.24.
//

import XCTest
import SwiftUI

@testable import BookingSense
import SwiftData

final class ConstantsTests: XCTestCase {

  func testListBackgroundColors() throws {
    XCTAssertEqual(
      Constants.listBackgroundColors[BookingType.plus],
      Color(UIColor(red: 0.2039, green: 0.7373, blue: 0.2039, alpha: 1.0))

    )
    XCTAssertEqual(
      Constants.listBackgroundColors[BookingType.minus],
      Color(UIColor(red: 0.7882, green: 0, blue: 0.0118, alpha: 1.0))
    )
  }

  func testGetBackground() throws {
    XCTAssertEqual(
      Constants.getBackground(ColorScheme.dark),
      Color(uiColor: UIColor(
        red: 64/255,
        green: 64/255,
        blue: 64/255,
        alpha: 1.0
      ))
    )
    XCTAssertEqual(
      Constants.getBackground(ColorScheme.light),
      .white
    )
  }

  func testGetSymbol() throws {
    let code = "plus"

    XCTAssertEqual(
      Constants.getSymbol(code),
      NSLocale(localeIdentifier: code).displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    )
  }
}
