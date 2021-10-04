//
//  Password_GeneratorScreenshotsIOS.swift
//  Password-GeneratorScreenshots (iOS)
//
//  Created by Kamaal Farah on 04/10/2021.
//

import XCTest

class Password_GeneratorScreenshotsIOS: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func tearDownWithError() throws { }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

}
