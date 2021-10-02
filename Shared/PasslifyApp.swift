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

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.context!)
        }
    }
}
