//
//  Clipboard.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 13/09/2021.
//

import SwiftUI

struct Clipboard {
    private init() { }

    static func copy(_ value: String) {
        #if os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(value, forType: .string)
        #else
        let pasteboard = UIPasteboard.general
        pasteboard.string = value
        #endif
    }
}
