//
//  CommandLine+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 14/10/2021.
//

import Foundation

extension CommandLine {
    enum ExpectedValues: String {
        case isUITesting
        case uiTestingLightMode = "UITestingLightMode"
        case uiTestingDarkMode = "UITestingDarkMode"
    }

    static func launchArgumentIncludes(value: ExpectedValues) -> Bool {
        CommandLine.arguments.contains(value.rawValue)
    }
}
