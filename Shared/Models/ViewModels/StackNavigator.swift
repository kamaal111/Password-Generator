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

    let registeredScreens: [Screens]

    init(registeredScreens: [Screens]) {
        self.registeredScreens = registeredScreens
    }

    enum Screens {
        case savedPasswordDetails

        var view: some View {
            switch self {
            case .savedPasswordDetails: return SavedPasswordDetailScreen()
            }
        }
    }

    func navigate(to screen: Screens?, options: [String: String] = [:]) {
        if let screen = screen, !registeredScreens.contains(screen) {
            console.error(Date(), "\(screen) is not registered")
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.selectedScreen = screen
        }
    }

}
