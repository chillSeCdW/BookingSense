//
//  ToastStyleTests.swift
//  ExpenseSenseTests
//
//  Created by Kenny Salazar on 28.04.24.
//

import XCTest
import SwiftUI
@testable import ExpenseSense

final class ToastStyleTests: XCTestCase {

  func testToastStyleError() throws {
    let toastStyle = ToastStyle.error

    XCTAssertEqual(toastStyle.color, Color.red)
    XCTAssertEqual(toastStyle.iconName, "xmark.circle.fill")
  }

  func testToastStyleInfo() throws {
    let toastStyle = ToastStyle.info

    XCTAssertEqual(toastStyle.color, Color.blue)
    XCTAssertEqual(toastStyle.iconName, "info.circle.fill")
  }

  func testToastStyleSuccess() throws {
    let toastStyle = ToastStyle.success

    XCTAssertEqual(toastStyle.color, Color.green)
    XCTAssertEqual(toastStyle.iconName, "checkmark.circle.fill")
  }

}
