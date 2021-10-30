//
//  AppDelegate_macOS.swift
//  Password-Generator (macOS)
//
//  Created by Kamaal M Farah on 19/09/2021.
//

import AppKit
import PGLocale
import ConsoleSwift
import CloudKit

class AppDelegate: NSObject, NSApplicationDelegate {

    private let cloudKitController = CloudKitController.shared

    func applicationDidFinishLaunching(_ notification: Notification) {
        guard let app = notification.object as? NSApplication else { return }

        buildMenu(app)

        app.registerForRemoteNotifications()
        cloudKitController.subscripeToAll()
    }

}

// MARK: Notifications

extension AppDelegate {
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String: Any]) {
        if let notification = CKNotification(fromRemoteNotificationDictionary: userInfo) {
            console.log(Date(), "CloudKit database changed", notification)
            NotificationCenter.default.post(name: .iCloudChanges, object: notification)
        }
    }

    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        console.log(Date(), "deviceToken", deviceToken.hexString)
    }

    func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        console.log(Date(), error.localizedDescription, error)
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
