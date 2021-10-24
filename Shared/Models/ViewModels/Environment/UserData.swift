//
//  UserData.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 23/10/2021.
//

import Foundation

final class UserData: ObservableObject {

    @Published var iCloudSyncingEnabled = UserDefaults.enableICloudSyncing {
        didSet { UserDefaults.enableICloudSyncing = iCloudSyncingEnabled }
    }
    @Published var lastChosenSyncMethod: CommonPassword.Source {
        didSet { UserDefaults.lastChosenSyncMethod = try? JSONEncoder().encode(lastChosenSyncMethod) }
    }

    init() {
        if let lastChosenSyncMethod = UserDefaults.lastChosenSyncMethod,
            let decodedLastChosenSyncMethod = try? JSONDecoder()
            .decode(CommonPassword.Source.self, from: lastChosenSyncMethod) {
            self.lastChosenSyncMethod = decodedLastChosenSyncMethod
        } else {
            self.lastChosenSyncMethod = .coreData
        }
    }

}
