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
    private var stackNavigator = StackNavigator(registeredScreens: [
        .logoPlayground,
        .keychainPlayground,
        .cloudPlayground
    ])

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                FormHeader(title: "Features")
                    .padding(.bottom, .xs)
                ForEach(Self.navigationButtonsData, id: \.self) { data in
                    Button(action: { stackNavigator.navigate(to: data.screen) }) {
                        Text(data.title)
                            .foregroundColor(.accentColor)
                            .font(.headline)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, .xs)
                }
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

    private static let navigationButtonsData = [
        NavigationButtonModel(title: "Customize logo", screen: .logoPlayground),
        NavigationButtonModel(title: "Keychain playground", screen: .keychainPlayground),
        NavigationButtonModel(title: "Cloud playground", screen: .cloudPlayground)
    ]

    private struct NavigationButtonModel: Hashable {
        let title: String
        let screen: StackNavigator.Screens
    }
}

struct PlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundScreen()
    }
}
#endif
