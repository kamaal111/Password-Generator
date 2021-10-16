//
//  Config.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 14/10/2021.
//

import Foundation

enum Config {
    static let isUITest = CommandLine.launchArgumentIncludes(value: .isUITesting)
}
