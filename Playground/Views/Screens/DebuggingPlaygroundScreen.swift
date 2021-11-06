//
//  DebuggingPlaygroundScreen.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 06/11/2021.
//

#if DEBUG
import SwiftUI

struct DebuggingPlaygroundScreen: View {
    var body: some View {
        PlaygroundScreenWrapper(title: "Debugging") {
            Text("Hello, World!")
        }
    }
}

struct DebuggingPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        DebuggingPlaygroundScreen()
    }
}
#endif
