//
//  CoreDataModel.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 06/09/2021.
//

import Foundation
import PersistanceManager
import ConsoleSwift
import ShrimpExtensions
import CoreData

final class CoreDataModel: ObservableObject {

    @Published private var savedPasswords: [CorePassword] = []

    let persistenceController: PersistanceManager

    init(preview: Bool = false) {
        if preview {
            self.persistenceController = PersistenceController.preview
        } else {
            self.persistenceController = PersistenceController.shared
        }
    }

    func checkForDuplicates(_ password: String) -> Bool {
        CorePassword.checkForDuplicatePasswords(password, context: persistenceController.context!)
    }

    func savePassword(of password: String, withName name: String) -> Bool {
        var unwrappedName: String? = name
        if name.replacingOccurrences(of: " ", with: "").isEmpty {
            unwrappedName = nil
        }
        let savedPasswordResult = CorePassword.saveNew(
            args: .init(name: unwrappedName, value: password),
            context: persistenceController.context!)
        let savedPassword: CorePassword
        switch savedPasswordResult {
        case .failure(let failure):
            console.error(Date(), failure.localizedDescription, failure)
            return false
        case .success(let success): savedPassword = success
        }
        savedPasswords = savedPasswords.prepended(savedPassword)
        return true
    }

}
