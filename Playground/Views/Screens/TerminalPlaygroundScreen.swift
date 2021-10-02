//
//  TerminalPlaygroundScreen.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 02/10/2021.
//

#if DEBUG
import SwiftUI

struct TerminalPlaygroundScreen: View {
    @EnvironmentObject
    private var stackNavigator: StackNavigator

    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .navigationTitle(Text("Terminal runner"))
        #if os(macOS)
        .toolbar(content: {
            ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                Button(action: { stackNavigator.navigate(to: nil) }) {
                    Image(systemName: "chevron.left")
                }
            }
        })
        #else
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct TerminalPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        TerminalPlaygroundScreen()
    }
}
#endif
