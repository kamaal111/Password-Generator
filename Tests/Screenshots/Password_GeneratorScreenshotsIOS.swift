//
//  Password_GeneratorScreenshotsIOS.swift
//  Password-GeneratorScreenshots (iOS)
//
//  Created by Kamaal Farah on 04/10/2021.
//

import XCTest
import PGLocale

final class Password_GeneratorScreenshotsIOS: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false

        app.launchArguments.append("isUITesting")
        setupSnapshot(app)
        app.launch()
    }

    override func tearDownWithError() throws { }

    func testLightMode() throws {
        if let darkModeStateIndex = app.launchArguments.firstIndex(of: "UITestingDarkMode") {
            app.launchArguments.remove(at: darkModeStateIndex)
        }
        app.launchArguments.append("UITestingLightMode")
        try screenshotFlow(scheme: "light")
    }

    func testDarkMode() throws {
        if let lightModeStateIndex = app.launchArguments.firstIndex(of: "UITestingLightMode") {
            app.launchArguments.remove(at: lightModeStateIndex)
        }
        app.launchArguments.append("UITestingDarkMode")
        try screenshotFlow(scheme: "dark")
    }

    private func screenshotFlow(scheme: String) throws {
        try homescreenScreenshot(scheme: scheme)
        savedPasswordsScreenShot(scheme: scheme)
        passwordDetailsScreenshot(scheme: scheme)
    }

    private func homescreenScreenshot(scheme: String) throws {
        let passwordLengthStepper = app.steppers["password-length-stepper"]
        _ = passwordLengthStepper.waitForExistence(timeout: 20)

        try passwordLengthStepper.incrementStepperUntil(value: 32)

        let generatePasswordButton = app.buttons[.GENERATE_BUTTON]
        generatePasswordButton.tap()

        let passwordLabel = app.staticTexts["password-label"]
        let passwordLabelValue = try XCTUnwrap(passwordLabel.value as? String)
        XCTAssertNotEqual(passwordLabelValue, PGLocale.Keys.PASSWORD_PLACEHOLDER.localized)

        let copyButton = app.buttons[.COPY]
        copyButton.tap()

        let copyCheckmark = app.images["checkmark-\(PGLocale.Keys.COPY.localized)"]
        _ = copyCheckmark.waitForExistence(timeout: 5)
        XCTAssert(copyCheckmark.exists)

        snapshot("home screen \(scheme)")
    }

    private func savedPasswordsScreenShot(scheme: String) {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: app.tabBars.buttons.element(boundBy: 1).tap()
        case .pad:
            let sidebarToggle = app.buttons["Back"]
            _ = sidebarToggle.waitForExistence(timeout: 5)
            sidebarToggle.tap()

            let savedPasswordsbutton = app.buttons[.SAVED_PASSWORDS]
            _ = savedPasswordsbutton.waitForExistence(timeout: 5)
            savedPasswordsbutton.tap()

            let passwordHeader = app.staticTexts[.PASSWORDS].firstMatch
            _ = passwordHeader.waitForExistence(timeout: 5)
            XCTAssert(passwordHeader.exists)

            let screenSize = UIScreen.main.bounds
            app.tapCoordinate(x: screenSize.width / 2, y: screenSize.height / 2)
        default: XCTFail("not implemented")
        }

        snapshot("saved passwords \(scheme)")
    }

    private func passwordDetailsScreenshot(scheme: String) {
        let savedPasswordOption = app.buttons["Very important account"]
        savedPasswordOption.tap()

        snapshot("password details \(scheme)")
    }

}

extension XCUIElementQuery {
    subscript(key: PGLocale.Keys) -> XCUIElement {
        get { self[key.localized] }
    }
}

extension XCUIElement {
    func tapCoordinate(x xCoordinate: Double, y yCoordinate: Double) {
        let normalized = self.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let coordinate = normalized.withOffset(CGVector(dx: xCoordinate, dy: yCoordinate))
        coordinate.tap()
    }

    func incrementStepperUntil(value: Int) throws {
        let stepperValue = try XCTUnwrap(self.value as? String)
        let stepperValueInt = try XCTUnwrap(Int(stepperValue))

        let remainder = value - stepperValueInt
        for _ in 0..<remainder {
            incrementStepper()
        }

        XCTAssertEqual(Int(self.value as? String ?? "") ?? 0, value)
    }

    func incrementStepper() {
        let button = self.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5))
        button.tap()
    }
}
