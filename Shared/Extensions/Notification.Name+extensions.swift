//
//  Notification.Name+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 10/09/2021.
//

import Foundation

extension Notification.Name {
    static let copyShortcutTriggered = Notification.Name(constructKey(with: "copyShortcutTriggered"))

    private static func constructKey(with value: String) -> String {
        "\(Constants.bundleIdentifier).notifications.\(value)"
    }
}
