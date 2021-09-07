//
//  PasswordHandlerTests.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 07/09/2021.
//

import XCTest
@testable import Password_Generator

class PasswordHandlerTests: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    func testNumeralsAreDisabled() throws {
        let length = 16
        let password = PasswordHandler(
            enableLowers: true,
            enableUppers: true,
            enableNumerals: false,
            enableSymbols: true)
            .create(length: length)
        XCTAssertEqual(password.count, length)
        for character in password {
            XCTAssert(!character.isNumber)
        }
    }

    func testLowercasedIsDisabled() throws {
        let length = 16
        let password = PasswordHandler(
            enableLowers: true,
            enableUppers: false,
            enableNumerals: true,
            enableSymbols: true)
            .create(length: length)
        XCTAssertEqual(password.count, length)
        for character in password {
            XCTAssert(!character.isUppercase)
        }
    }

    func testUppercasedIsDisabled() throws {
        let length = 16
        let password = PasswordHandler(
            enableLowers: false,
            enableUppers: true,
            enableNumerals: true,
            enableSymbols: true)
            .create(length: length)
        XCTAssertEqual(password.count, length)
        for character in password {
            XCTAssert(!character.isLowercase)
        }
    }

    func testSymbolsIsDisabled() throws {
        let length = 16
        let password = PasswordHandler(
            enableLowers: true,
            enableUppers: true,
            enableNumerals: true,
            enableSymbols: false)
            .create(length: length)
        XCTAssertEqual(password.count, length)
        for character in password {
            XCTAssert(!character.isSymbol)
        }
    }

    func testNoCharactersGetReturned() throws {
        let length = 16
        let password = PasswordHandler(
            enableLowers: false,
            enableUppers: false,
            enableNumerals: false,
            enableSymbols: false)
            .create(length: length)
        XCTAssert(password.isEmpty)
    }

}
