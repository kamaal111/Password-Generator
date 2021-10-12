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

    init() {
        setupObservers()
    }

    deinit {
        removeObservers()
    }

    enum NavigationStacks: Int, CaseIterable, Codable {
        case home = 0
        case savedPasswords = 1
        case settings = 2
        #if DEBUG && os(macOS)
        case playground = 420
        #endif
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

    private func setupObservers() {
        #if DEBUG && os(macOS)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePlaygroundMenuItemPress),
            name: .playgroundMenuItem,
            object: nil)
        #endif
    }

    private func removeObservers() {
        #if DEBUG && os(macOS)
        NotificationCenter.default.removeObserver(
            self,
            name: .playgroundMenuItem,
            object: nil)
        #endif
    }

    #if DEBUG && os(macOS)
    @objc
    private func handlePlaygroundMenuItemPress(_ notifcation: Notification? = nil) {
        navigateToStack(.playground)
    }
    #endif

}
