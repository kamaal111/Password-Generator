//
//  SavedPasswordsManager.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 06/09/2021.
//

import Foundation
import PersistanceManager
import ConsoleSwift
import ShrimpExtensions
import CoreData
import SwiftUI

final class SavedPasswordsManager: ObservableObject {

    @Published private(set) var passwords: [CommonPassword] = []
    @Published private(set) var lastGeneratedPassword: String?
    @Published var deletionAlertIsActive = false
    @Published private var passwordToDeleteID: UUID? {
        didSet { passwordToDeleteIDDidSet() }
    }

    private let persistenceController: PersistanceManager
    private let cloudKitController = CloudKitController.shared

    init(preview: Bool = false) {
        if preview || Config.isUITest {
            self.persistenceController = PersistenceController.preview
        } else {
            self.persistenceController = PersistenceController.shared
        }
    }

    func onPasswordDelete(_ password: CommonPassword) {
        passwordToDeleteID = password.id
    }

    func onDefinitePasswordDeletion() {
        guard let passwordToDeleteID = self.passwordToDeleteID,
              let index = passwords.findIndex(by: \.id, is: passwordToDeleteID) else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let removedPassword = self.passwords.remove(at: index)
            self.passwordToDeleteID = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                switch removedPassword.source {
                case .coreData:
                    guard let coreDataItem = try? removedPassword
                            .toCoreDataItem(context: self.persistenceController.context!).get() else { return }
                    do {
                        try self.persistenceController.delete(coreDataItem)
                    } catch {
                        console.error(Date(), error.localizedDescription, error)
                        return
                    }
                case .iCloud:
                    self.cloudKitController.delete(removedPassword.toCloudKitItem, completion: { result in
                        switch result {
                        case .failure(let failure):
                            console.error(Date(), failure.localizedDescription, failure)
                            return
                        case .success(let success):
                            console.log(Date(), "deleted \(success)")
                        }
                    })
                    return
                }
            }
        }
    }

    func editPassword(id: UUID, args: CommonPassword.Args) {
        guard let index = passwords.firstIndex(where: { $0.id == id }) else { return }
        let password = passwords[index]
        #error("Uncomment")
//        let editedPasswordResult = password.edit(args: args)
//        let editedPassword: CorePassword
//        switch editedPasswordResult {
//        case .failure(let failure):
//            console.error(Date(), failure.localizedDescription, failure)
//            return
//        case .success(let success): editedPassword = success
//        }
//        passwords[index] = editedPassword
    }

    func getPasswordByID(is comparisonValue: UUID) -> CommonPassword? {
        passwords.find(by: \.id, is: comparisonValue)
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
        #error("Uncomment")
//        passwords = allPasswords.reversed()
    }

    func savePassword(of password: String, withName name: String) -> Bool {
        var unwrappedName: String? = name
        if name.replacingOccurrences(of: " ", with: "").isEmpty {
            unwrappedName = nil
        }
        let savedPasswordResult = CorePassword.saveNew(
            args: .init(name: unwrappedName, value: password),
            context: persistenceController.context!)
        #error("Uncomment")
//        let savedPassword: CorePassword
//        switch savedPasswordResult {
//        case .failure(let failure):
//            console.error(Date(), failure.localizedDescription, failure)
//            return false
//        case .success(let success): savedPassword = success
//        }
//        passwords = passwords.prepended(savedPassword)
        return true
    }

    private func passwordToDeleteIDDidSet() {
        if passwordToDeleteID != nil {
            deletionAlertIsActive = true
        } else {
            deletionAlertIsActive = false
        }
    }

}
