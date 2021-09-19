//
//  PlaygroundScreen.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 19/09/2021.
//

#if DEBUG
import SwiftUI

struct PlaygroundScreen: View {
    var body: some View {
        #if os(macOS)
        view
        #else
        view
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    private var view: some View {
        Text("Hello, World!")
    }
}

struct PlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundScreen()
    }
}
#endif
