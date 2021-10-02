//
//  PlaygroundScreen.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 19/09/2021.
//

#if DEBUG
import SwiftUI
import SalmonUI

struct PlaygroundScreen: View {
    @StateObject
    private var stackNavigator = StackNavigator(registeredScreens: [.logoPlayground])

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                FormHeader(title: "Features")
                Button(action: { stackNavigator.navigate(to: .logoPlayground) }) {
                    Text("Customize logo")
                        .foregroundColor(.accentColor)
                        .font(.headline)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.bottom, .small)
        }
        .ktakeSizeEagerly(alignment: .topLeading)
        .padding(.horizontal, .large)
        .padding(.vertical, .medium)
        .navigationTitle(Text("Playground"))
        .withNavigationPoints(selectedScreen: $stackNavigator.selectedScreen, stackNavigator: stackNavigator)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct PlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundScreen()
    }
}
#endif
