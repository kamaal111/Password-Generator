//
//  Persistence.swift
//  Shared
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import CoreData
import PersistanceManager
import ConsoleSwift

struct PersistenceController {
    private let sharedInststance: PersistanceManager

    private init(inMemory: Bool = false) {
        let persistanceContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Password_Generator")
            if inMemory {
                container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
            } else {
                guard let defaultUrl = container.persistentStoreDescriptions.first?.url
                else { fatalError("Default url not found") }
                let defaultStore = NSPersistentStoreDescription(url: defaultUrl)
                defaultStore.configuration = "Default"
                defaultStore.shouldMigrateStoreAutomatically = true
                defaultStore.shouldInferMappingModelAutomatically = true
            }
            container.loadPersistentStores { (_: NSPersistentStoreDescription, error: Error?) in
                if let error = error as NSError? {
                    console.error(Date(), "Unresolved error \(error),", error.userInfo)
                }
            }
            return container
        }()
        self.sharedInststance = PersistanceManager(container: persistanceContainer)
    }

    static let shared = PersistenceController().sharedInststance

    static let preview: PersistanceManager = {
        let result = PersistenceController(inMemory: true).sharedInststance
        let names = [
            "Bank of Skyrim",
            "Life savings vault",
            "Very important account",
            "Guessable password",
            "Main gaming account",
            "Credentials",
            "Identity"
        ]
        for name in names {
            let args = CorePassword.Args(name: name, value: "password")
            CorePassword.saveNew(args: args, context: result.context!, save: false)
        }
        return result
    }()
}
