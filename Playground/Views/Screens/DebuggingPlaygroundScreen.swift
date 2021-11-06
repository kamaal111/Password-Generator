//
//  DebuggingPlaygroundScreen.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 06/11/2021.
//

#if DEBUG
import SwiftUI

struct DebuggingPlaygroundScreen: View {
    @EnvironmentObject
    private var savedPasswordsManager: SavedPasswordsManager

    @State private var loading = false

    var body: some View {
        PlaygroundScreenWrapper(title: "Debugging") {
            if loading {
                LoadingIndicator(loading: $loading)
            } else {
                ForEach(savedPasswordsManager.passwords) { password in
                    Text("\(password.source.rawValue)")
                }
            }
        }
        .onAppear(perform: {
            loading = true
            savedPasswordsManager.fetchAllPasswords(completion: {
                loading = false
            })
        })
    }
}

struct DebuggingPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        DebuggingPlaygroundScreen()
            .environmentObject(SavedPasswordsManager(preview: true))
    }
}
#endif
