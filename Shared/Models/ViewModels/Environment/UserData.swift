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

}
