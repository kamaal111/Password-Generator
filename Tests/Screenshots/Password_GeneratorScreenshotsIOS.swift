//
//  Password_GeneratorScreenshotsIOS.swift
//  Password-GeneratorScreenshots (iOS)
//
//  Created by Kamaal Farah on 04/10/2021.
//

import XCTest
import PGLocale

class Password_GeneratorScreenshotsIOS: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws { }

    func testExample() throws {
        let app = XCUIApplication()
        app.launchArguments.append("isUITesting")
        setupSnapshot(app)
        app.launch()

        let passwordLengthStepper = app.steppers["password-length-stepper"]
        _ = passwordLengthStepper.waitForExistence(timeout: 20)

        try passwordLengthStepper.incrementStepperUntil(value: 32)

        let generatePasswordButton = app.buttons[PGLocale.Keys.GENERATE_BUTTON.localized]
        generatePasswordButton.tap()

        let passwordLabel = app.staticTexts["password-label"]
        let passwordLabelValue = try XCTUnwrap(passwordLabel.value as? String)
        XCTAssertNotEqual(passwordLabelValue, PGLocale.Keys.PASSWORD_PLACEHOLDER.localized)

        let copyButton = app.buttons[PGLocale.Keys.COPY.localized]
        copyButton.tap()

        let copyCheckmark = app.images["checkmark-\(PGLocale.Keys.COPY.localized)"]
        _ = copyCheckmark.waitForExistence(timeout: 5)
        XCTAssert(copyCheckmark.exists)

        snapshot("home screen")
    }

}

// - TODO: PUT THIS IN A SEPERATE FILE
extension XCUIElement {
    func incrementStepperUntil(value: Int) throws {
        let stepperValue = try XCTUnwrap(self.value as? String)
        let stepperValueInt = try XCTUnwrap(Int(stepperValue))

        let remainder = value - stepperValueInt
        for _ in 0..<remainder {
            self.incrementStepper()
        }

        XCTAssertEqual(Int(self.value as? String ?? "") ?? 0, value)
    }

    func incrementStepper() {
        let button = self.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5))
        button.tap()
    }
}
