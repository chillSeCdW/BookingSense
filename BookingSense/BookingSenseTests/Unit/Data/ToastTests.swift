//
//  ToastTests.swift
//  BookingSenseTests
//
//  Created by kenny on 28.04.24.
//

import XCTest
@testable import BookingSense

final class ToastTests: XCTestCase {

    func testToastDefaults() throws {
      let toast = Toast(style: .info, title: "someTitle", message: "someMessage")

      XCTAssertEqual(toast, Toast(
        style: .info,
        title: "someTitle",
        message: "someMessage",
        duration: 2,
        width: .infinity)
      )
    }

}
