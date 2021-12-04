//
//  Logger+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 04/12/2021.
//

import os.log

extension Logger {
    private static let key = Constants.bundleIdentifier.appending(".logger")

    static let iCloud = Logger(subsystem: key, category: "icloud")
}
