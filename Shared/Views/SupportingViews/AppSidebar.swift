//
//  AppSidebar.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI
import PGLocale

struct AppSidebar: View {
    @EnvironmentObject
    private var namiNavigator: NamiNavigator

    var body: some View {
        #if os(macOS)
        view()
            .toolbar(content: {
                Button(action: toggleSidebar) {
                    Label(PGLocale.Keys.TOGGLE_SIDEBAR.localized, systemImage: "sidebar.left")
                }
            })
        #else
        view()
        #endif
    }

    private func view() -> some View {
        List {
            ForEach(NamiNavigator.sidebarItems, content: { item in
                Button(action: {
                    namiNavigator.navigateToStack(item.navigationPoint)
                }) {
                    Label(item.title, systemImage: item.systemImage)
                }
                .buttonStyle(PlainButtonStyle())
            })
        }
    }

    #if os(macOS)
    private func toggleSidebar() {
        guard let firstResponder = NSApp.keyWindow?.firstResponder else { return }
        firstResponder.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    #endif
}

struct AppSidebar_Previews: PreviewProvider {
    static var previews: some View {
        AppSidebar()
            .environmentObject(NamiNavigator())
    }
}
