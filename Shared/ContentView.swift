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

    var body: some View {
        #if os(macOS)
        injectViewWithEnvironment(
            MacContentView()
                .frame(minWidth: 305, minHeight: 305))
        #else
        injectViewWithEnvironment(IOSContentView())
        #endif
    }

    private func injectViewWithEnvironment<V: View>(_ view: V) -> some View {
        view
            .environmentObject(namiNavigator)
    }
}

#if os(iOS)
struct IOSContentView: View {
    var body: some View {
        if UIDevice.isIpad {
            SidebarView()
        } else {
            TabbarView()
        }
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
