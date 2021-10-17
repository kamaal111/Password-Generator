//
//  KeychainPlaygroundScreen.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 17/10/2021.
//

#if DEBUG
import SwiftUI
import SalmonUI
import Security

struct KeychainPlaygroundScreen: View {
    @EnvironmentObject
    private var stackNavigator: StackNavigator

    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello, World!")
        }
        .ktakeSizeEagerly(alignment: .topLeading)
        .padding(.horizontal, .large)
        .padding(.vertical, .medium)
        .navigationTitle(Text("Keychain playground"))
        .macBackButton(action: {
            stackNavigator.navigate(to: nil)
        })
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct KeychainPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        KeychainPlaygroundScreen()
    }
}
#endif
