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
        Text("Hello, World!")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundScreen()
    }
}
#endif
