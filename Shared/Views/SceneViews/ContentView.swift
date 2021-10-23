//
//  ContentView.swift
//  Shared
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject
    private var namiNavigator = NamiNavigator()
    @StateObject
    private var deviceModel = DeviceModel()
    @StateObject
    private var savedPasswordsManager = SavedPasswordsManager()

    var body: some View {
        #if os(macOS)
        injectViewWithEnvironment(
            MacContentView()
                .frame(minWidth: 305, minHeight: 305)
            /// - FIXME: NOT WORKING FOR SOME REASON
                .onCopyCommand(perform: handleCopyCommand)
                .onCutCommand(perform: handleCopyCommand)
        )
        #else
        injectViewWithEnvironment(IOSContentView())
        #endif
    }

    private func injectViewWithEnvironment<V: View>(_ view: V) -> some View {
        view
            .environmentObject(namiNavigator)
            .environmentObject(deviceModel)
            .environmentObject(savedPasswordsManager)
    }

    #if os(macOS)
    private func handleCopyCommand() -> [NSItemProvider] {
        var items: [NSItemProvider] = []
        if let lastGeneratedPassword = savedPasswordsManager.lastGeneratedPassword {
            print("lastGeneratedPassword", lastGeneratedPassword)
            NotificationCenter.default.post(name: .copyShortcutTriggered, object: lastGeneratedPassword)
            items.append(NSItemProvider(object: lastGeneratedPassword as NSItemProviderWriting))
        }
        return items
    }
    #endif
}

#if os(iOS)
struct IOSContentView: View {
    @State private var showPlayground = true

    var body: some View {
        ZStack {
            if DeviceModel.device == .iPad {
                SidebarView()
            } else {
                TabbarView()
            }
        }
        .withSplashScreen(isActive: showPlayground)
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation { showPlayground = false }
            }
        })
    }
}
#endif

#if os(macOS)
struct MacContentView: View {
    var body: some View {
        SidebarView()
            .frame(minWidth: 305, minHeight: 305)
    }
}
#endif

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.context!)
    }
}
