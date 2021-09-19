//
//  Notification.Name+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 10/09/2021.
//

import Foundation

extension Notification.Name {
    #if os(macOS)
    static let copyShortcutTriggered = Notification.Name(constructKey(with: "copyShortcutTriggered"))
    #if DEBUG
    static let playgroundMenuItem = Notification.Name(constructKey(with: "playgroundMenuItem"))
    #endif
    #endif

    private static func constructKey(with value: String) -> String {
        "\(Constants.bundleIdentifier).notifications.\(value)"
    }
}
