//
//  SourceChangerPlaygroundScreen.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 06/11/2021.
//

#if DEBUG
import SwiftUI

@available(macOS 12.0.0, iOS 15.0.0, *)
struct SourceChangerPlaygroundScreen: View {
    @EnvironmentObject
    private var savedPasswordsManager: SavedPasswordsManager

    @State private var loading = false

    var body: some View {
        PlaygroundScreenWrapper(title: "Source changer") {
            if loading {
                LoadingIndicator(loading: $loading)
            } else {
                Section(header: Text("Passwords")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, .xs)) {
                    ForEach(savedPasswordsManager.passwords) { password in
                        Button(action: {
                            let currentArgs = password.args
                            let newArgs = CommonPassword.Args(
                                id: currentArgs.id,
                                name: currentArgs.name,
                                value: currentArgs.value,
                                creationDate: currentArgs.creationDate,
                                source: currentArgs.source == .iCloud ? .coreData : .iCloud)
                        }) {
                            Text("\(password.source.rawValue)")
                                .bold()
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.bottom, .xs)
                    }
                }
            }
        }
        .onAppear(perform: {
            loading = true
            Task {
                await savedPasswordsManager.fetchAllPasswords()
                loading = false
            }
        })
    }
}

@available(macOS 12.0.0, iOS 15.0.0, *)
struct SourceChangerPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        SourceChangerPlaygroundScreen()
            .environmentObject(SavedPasswordsManager(preview: true))
    }
}
#endif
