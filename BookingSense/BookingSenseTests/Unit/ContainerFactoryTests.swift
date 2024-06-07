//
//  ContainerFactoryTests.swift
//  ContainerFactoryTests
//
//  Created by kenny on 27.04.24.
//

import XCTest
@testable import BookingSense

 final class ContainerFactoryTests: XCTestCase {

   func testContainerFactoryHappy() throws {
     let factory = ContainerFactory(BookingEntry.self, storeInMemory: true)
     factory.addExamples(ContainerFactory.generateRandomEntriesItems())
     XCTAssertNotNil(factory.container)
   }
 }
