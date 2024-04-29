//
//  ToastTests.swift
//  ExpenseSenseTests
//
//  Created by Kenny Salazar on 28.04.24.
//

import XCTest
@testable import ExpenseSense

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
