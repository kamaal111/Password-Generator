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

    @Published private(set) var savedPasswords: [CorePassword] = []
    @Published private(set) var lastGeneratedPassword: String?
    @Published var deletionAlertIsActive = false

    let persistenceController: PersistanceManager

    init(preview: Bool = false) {
        if preview {
            self.persistenceController = PersistenceController.preview
        } else {
            self.persistenceController = PersistenceController.shared
        }
    }

    func onPasswordDelete(_ password: CorePassword) {
        deletionAlertIsActive = true
        print("password", password)
    }

    func editPassword(id: UUID, args: CorePassword.Args) {
        guard let index = savedPasswords.firstIndex(where: { $0.id == id }) else { return }
        let password = savedPasswords[index]
        let editedPasswordResult = password.edit(args: args)
        let editedPassword: CorePassword
        switch editedPasswordResult {
        case .failure(let failure):
            console.error(Date(), failure.localizedDescription, failure)
            return
        case .success(let success): editedPassword = success
        }
        savedPasswords[index] = editedPassword
    }

    func getPasswordByID(is comparisonValue: UUID) -> CorePassword? {
        savedPasswords.find(by: \.id, is: comparisonValue)
    }

    func setLastGeneratedPassword(with password: String) {
        lastGeneratedPassword = password
    }

    func checkForDuplicates(_ password: String) -> Bool {
        CorePassword.checkForDuplicatePasswords(password, context: persistenceController.context!)
    }

    func fetchAllPasswords() {
        let allPasswordsResult = CorePassword.fetchAllPasswords(context: persistenceController.context!)
        let allPasswords: [CorePassword]
        switch allPasswordsResult {
        case .failure(let failure):
            console.error(Date(), failure.localizedDescription, failure)
            return
        case .success(let success): allPasswords = success
        }
        savedPasswords = allPasswords.reversed()
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
