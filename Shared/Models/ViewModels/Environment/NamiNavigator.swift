//
//  NamiNavigator.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import Foundation

final class NamiNavigator: ObservableObject {

    @Published var selectedStack: NavigationStacks?
    #if os(iOS)
    @Published var selectedTab = 0
    #endif

    enum NavigationStacks: Int, CaseIterable, Codable {
        case home = 0
    }

    func navigateToStack(_ screen: NavigationStacks?) {
        DispatchQueue.main.async { [weak self] in
            self?.selectedStack = screen
        }
    }

    static let sidebarItems: [ScreenModel] = ScreenModel
        .decodeFromJSON(withFileName: "sidebarItems")
        .filter(\.isNotExcluded)

    #if os(iOS)
    static let tabbarItems: [ScreenModel] = ScreenModel
        .decodeFromJSON(withFileName: "tabbarItems")
        .filter(\.isNotExcluded)
    #endif

}
