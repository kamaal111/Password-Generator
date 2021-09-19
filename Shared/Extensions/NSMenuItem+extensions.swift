//
//  NSMenuItem+extensions.swift
//  Password-Generator (macOS)
//
//  Created by Kamaal M Farah on 19/09/2021.
//

import AppKit

extension NSMenuItem {
    func setTag(with menuItemsTag: MenuItemTags) {
        self.tag = menuItemsTag.rawValue
    }
}
