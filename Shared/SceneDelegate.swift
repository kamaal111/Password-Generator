//
//  SceneDelegate.swift
//  Password-Generator (iOS)
//
//  Created by Kamaal M Farah on 15/10/2021.
//

import UIKit
import ConsoleSwift

class SceneDelegate: NSObject, UIWindowSceneDelegate {

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
            #if DEBUG
            if let windowScene = scene as? UIWindowScene {
                windowScene.windows.forEach({ window in
                    if CommandLine.launchArgumentIncludes(value: .uiTestingDarkMode) {
                        window.overrideUserInterfaceStyle = .dark
                    } else if CommandLine.launchArgumentIncludes(value: .uiTestingLightMode) {
                        window.overrideUserInterfaceStyle = .light
                    }
                })
            }
            #endif
    }

}

// MARK: Life Cycle Methods

extension SceneDelegate {
    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) {
        do {
            try PersistenceController.shared.save()
        } catch {
            console.error(Date(), "Could not save when entering background", error)
        }
    }
}
