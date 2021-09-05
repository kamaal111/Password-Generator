//
//  SidebarView.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject
    private var namiNavigator: NamiNavigator

    var body: some View {
        NavigationView {
            AppSidebar()
            MainView(selectedStack: namiNavigator.selectedStack)
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
            .environmentObject(NamiNavigator())
    }
}
