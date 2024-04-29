//
//  ContainerFactoryTests.swift
//  ContainerFactoryTests
//
//  Created by Kenny Salazar on 27.04.24.
//

import XCTest
@testable import ExpenseSense

 final class ContainerFactoryTests: XCTestCase {

   func testContainerFactoryHappy() throws {
     let factory = ContainerFactory(ExpenseEntry.self, storeInMemory: true)
     factory.addExamples(ContainerFactory.generateRandomEntriesItems())
     XCTAssertNotNil(factory.container)
   }
 }
