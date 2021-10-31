//
//  CommonPasswordTests.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 31/10/2021.
//

import XCTest
@testable import Passlify

class CommonPasswordTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testInsert() throws {
        let args = CommonPassword.Args(
            id: UUID(),
            name: "Bank safe",
            value: "secret password",
            creationDate: Date(),
            source: .coreData)
        CommonPassword.insert(
            args: args,
            context: PersistenceController.emptyPreview.context) { result in
            }
        XCTAssert(false)
    }

}
