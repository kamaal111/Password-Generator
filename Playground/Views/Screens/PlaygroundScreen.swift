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
        .cloudPlayground,
        .debuggingPlayground
    ])

    var body: some View {
        VStack(alignment: .leading) {
            PlaygroundScreenSection(
                headerTitle: "Features",
                navigationData: Self.featuresNavigationButtons,
                navigate: { screen in stackNavigator.navigate(to: screen) })
            PlaygroundScreenSection(
                headerTitle: "Miscellaneous",
                navigationData: Self.miscellaneousNavigationButtons,
                navigate: { screen in stackNavigator.navigate(to: screen) })
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

    private static let featuresNavigationButtons = [
        PlaygroundNavigationButtonModel(title: "Customize logo", screen: .logoPlayground),
        PlaygroundNavigationButtonModel(title: "Keychain playground", screen: .keychainPlayground),
        PlaygroundNavigationButtonModel(title: "Cloud playground", screen: .cloudPlayground)
    ]

    private static let miscellaneousNavigationButtons = [
        PlaygroundNavigationButtonModel(title: "Debugging", screen: .debuggingPlayground)
    ]
}

struct PlaygroundScreenSection: View {
    let headerTitle: String
    let navigationData: [PlaygroundNavigationButtonModel]
    let navigate: (_ screen: StackNavigator.Screens) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            FormHeader(title: headerTitle)
                .padding(.bottom, .xs)
            ForEach(navigationData, id: \.self) { data in
                Button(action: { navigate(data.screen) }) {
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
}

struct PlaygroundNavigationButtonModel: Hashable {
    let title: String
    let screen: StackNavigator.Screens
}

struct PlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundScreen()
    }
}
#endif
