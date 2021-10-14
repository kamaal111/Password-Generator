//
//  PasslifyApp.swift
//  Shared
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI

@main
struct PasslifyApp: App {
    #if os(macOS)
    @NSApplicationDelegateAdaptor
    private var appDelegate: AppDelegate
    #endif

    private let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.context!)
                // - TODO: MAKE THIS ONLY WORK FOR WHEN TAKING SCREENSHOTS
                #if DEBUG
                .colorScheme(CommandLine.launchArgumentIncludes(value: .uiTestingDarkMode) ? .dark : .light)
                #endif
        }
        #if os(macOS)
        Settings {
            SettingsView()
                .frame(width: 350, height: 305)
        }
        #endif
    }
}
