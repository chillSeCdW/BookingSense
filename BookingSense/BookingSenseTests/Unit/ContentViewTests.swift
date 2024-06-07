//
//  ContentViewTests.swift
//  BookingSenseTests
//
//  Created by kenny on 28.04.24.
//

import XCTest
import SwiftUI
@testable import BookingSense

final class ContentViewTests: XCTestCase {

    func testContentView() throws {
      let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
      factory.addExamples(ContainerFactory.generateRandomEntriesItems())
      let content = ContentView().modelContainer(factory.container)

      @State var toast: Toast? = Toast(
        style: .info,
        title: String(localized: "Info"),
        message: "someMessage",
        duration: 10,
        width: 160
      )

      XCTAssertNotNil(content.toastView(toast: $toast))
    }
}
