//
//  ToastStyleTests.swift
//  BookingSenseTests
//
//  Created by kenny on 28.04.24.
//

import XCTest
import SwiftUI
@testable import BookingSense

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
