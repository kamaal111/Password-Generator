//
//  AppDelegate_iOS.swift
//  Password-Generator (iOS)
//
//  Created by Kamaal M Farah on 15/10/2021.
//

import UIKit
import CloudKit
import ConsoleSwift

class AppDelegate: NSObject, UIApplicationDelegate {

    private let cloudKitController = CloudKitController.shared

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
            application.registerForRemoteNotifications()

            cloudKitController.subscripeToAll()

            return true
        }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
            sceneConfig.delegateClass = SceneDelegate.self
            return sceneConfig
    }

}

// - MARK: Notifactions

extension AppDelegate {
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            if let notification = CKNotification(fromRemoteNotificationDictionary: userInfo) {
                console.log(Date(), "CloudKit database changed", notification)
                NotificationCenter.default.post(name: .iCloudChanges, object: notification)
                completionHandler(.newData)
                return
            }
        }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        console.log(Date(), error.localizedDescription, error)
    }
}
