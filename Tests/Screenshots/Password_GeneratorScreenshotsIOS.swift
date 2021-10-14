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
        false
    }

    override func tearDownWithError() throws { }

    func testExample() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        let passwordLengthStepper = app.steppers["password-length-stepper"]
        _ = passwordLengthStepper.waitForExistence(timeout: 20)

        passwordLengthStepper.incrementStepperUntil(value: 32)
    }

}

extension XCUIElement {
    func incrementStepperUntil(value: Int) {
        guard let stepperValue = self.value as? String, let stepperValueInt = Int(stepperValue) else {
            XCTFail("stepper does not have a int value")
            return
        }

        let remainder = value - stepperValueInt
        for _ in 0..<remainder {
            self.incrementStepper()
        }

        guard let stepperValue = self.value as? String, let stepperValueInt = Int(stepperValue) else {
            XCTFail("stepper does not have a int value")
            return
        }

        XCTAssertEqual(stepperValueInt, value)
    }

    func incrementStepper() {
        let button = self.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5))
        button.tap()
    }
}
