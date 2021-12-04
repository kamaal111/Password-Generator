//
//  StackNavigator.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 13/09/2021.
//

import SwiftUI
import ConsoleSwift

final class StackNavigator: ObservableObject {

    @Published var selectedScreen: Screens?
    @Published private(set) var currentOptions: [String: String]?

    let registeredScreens: [Screens]

    init(registeredScreens: [Screens]) {
        self.registeredScreens = registeredScreens
    }

    enum Screens {
        case savedPasswordDetails
        #if DEBUG
        case playground
        case logoPlayground
        case keychainPlayground
        case cloudPlayground
        case sourceChangerPlayground
        #endif

        var view: some View {
            ZStack {
                switch self {
                case .savedPasswordDetails: SavedPasswordDetailScreen()
                #if DEBUG
                case .playground: PlaygroundScreen()
                case .logoPlayground: LogoPlaygroundScreen()
                case .keychainPlayground: KeychainPlaygroundScreen()
                case .cloudPlayground:
                    if #available(macOS 12.0.0, iOS 15.0.0, *) {
                        CloudPlaygroundScreen()
                    } else {
                        Text("Not available for your version")
                    }
                case .sourceChangerPlayground:
                    if #available(macOS 12.0.0, iOS 15.0.0, *) {
                        SourceChangerPlaygroundScreen()
                    } else {
                        Text("Not available for your version")
                    }
                #endif
                }
            }
        }
    }

    func navigate(to screen: Screens?, options: [String: String]? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.selectedScreen = screen
            self.currentOptions = options
        }
    }

}
