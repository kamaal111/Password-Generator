//
//  Password_GeneratorApp.swift
//  Shared
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI

@main
struct Password_GeneratorApp: App { // swiftlint:disable:this type_name
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
