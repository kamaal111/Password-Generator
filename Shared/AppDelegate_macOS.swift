//
//  AppDelegate_macOS.swift
//  Password-Generator (macOS)
//
//  Created by Kamaal M Farah on 19/09/2021.
//

import AppKit
import PGLocale

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        guard let app = notification.object as? NSApplication else { return }
        buildMenu(app)
    }
}

// MARK: Building Menu

extension AppDelegate {
    private func buildMenu(_ app: NSApplication) {
        guard let mainMenu = app.mainMenu else { return }
        buildHelpMenu(mainMenu: mainMenu)
    }

    private func buildHelpMenu(mainMenu: NSMenu) {
        guard let helpMenu = mainMenu.items.last?.submenu else { return }
        mainMenu.removeItem(at: mainMenu.items.count - 1)
        let helpMenuItem = NSMenuItem(title: PGLocale.Keys.HELP.localized, action: nil, keyEquivalent: "")
        mainMenu.addItem(helpMenuItem)
        mainMenu.setSubmenu(helpMenu, for: helpMenuItem)
        var newHelpMenuItems = helpMenu.items
        _ = newHelpMenuItems.popLast()
        #if DEBUG
        let playgroundMenuItem = NSMenuItem(
            title: "Playground",
            action: #selector(handleMenuItemPress),
            keyEquivalent: "D")
        playgroundMenuItem.setTag(with: .playground)
        newHelpMenuItems.append(playgroundMenuItem)
        #endif
        helpMenu.items = newHelpMenuItems
    }

    @objc
    private func handleMenuItemPress(_ item: NSMenuItem) {
        guard let menuItemTag = MenuItemTags(rawValue: item.tag) else { return }
        switch menuItemTag {
        case .appHelp:
            /// - TODO: Handle this
            print("app help")
        #if DEBUG
        case .playground:
            NotificationCenter.default.post(name: .playgroundMenuItem, object: nil)
        #endif
        }
    }
}
