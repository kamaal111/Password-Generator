//
//  MainView.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI

struct MainView: View {
    let selectedStack: NamiNavigator.NavigationStacks?

    var body: some View {
        switch selectedStack {
        case .none, .home: HomeScreen()
        case .savedPasswords: SavedPasswordsScreen()
        #if DEBUG && os(macOS)
        case .playground: PlaygroundScreen()
        #endif
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(NamiNavigator.NavigationStacks.allCases, id: \.self) { stack in
            MainView(selectedStack: stack)
        }
    }
}
