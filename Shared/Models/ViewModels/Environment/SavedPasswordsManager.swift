//
//  SavedPasswordsManager.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 06/09/2021.
//

import PersistanceManager
import ConsoleSwift
import ShrimpExtensions
import SwiftUI
import CloudKit

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

                removedPassword.delete(context: self.persistenceController.context!) { result in
                    switch result {
                    case .failure(let failure):
                        switch failure {
                        case .contextNotFound: console.error(Date(), failure)
                        case .coreDataError(error: let error): console.error(Date(), error)
                        case .coreDataValueNotFound: console.error(Date(), failure)
                        case .cloudKitError(error: let error): console.error(Date(), error)
                        }
                        return
                    case .success(_): break
                    }
                }
            }
        }
    }

    func editPassword(id: UUID, args: CommonPassword.Args) {
        guard let index = passwords.firstIndex(where: { $0.id == id }) else { return }
        let password = passwords[index]
        password.update(args: args, context: persistenceController.context!) { result in
            let editedPassword: CommonPassword
            switch result {
            case .failure(let failure):
                switch failure {
                case .contextNotFound: console.error(Date(), failure)
                case .coreDataError(error: let error): console.error(Date(), error)
                case .coreDataValueNotFound: console.error(Date(), failure)
                case .cloudKitError(error: let error): console.error(Date(), error)
                }
                return
            case .success(let success): editedPassword = success
            }

            DispatchQueue.main.async { [weak self] in
                self?.passwords[index] = editedPassword
            }
        }
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

    func fetchAllPasswords(completion: @escaping () -> Void) {
        let allPasswordsResult = CorePassword.fetchAllPasswords(context: persistenceController.context!)
        let allPasswords: [CorePassword]
        switch allPasswordsResult {
        case .failure(let failure):
            console.error(Date(), failure.localizedDescription, failure)
            allPasswords = []
        case .success(let success): allPasswords = success
        }

        let commonPasswordsFromCoreData = allPasswords.map(\.common)

        cloudKitController.fetchAll(ofType: CorePassword.recordType) { result in
            let records: [CKRecord]
            switch result {
            case .failure(let failure):
                console.log(Date(), failure.localizedDescription, failure)
                records = []
            case .success(let success): records = success
            }

            let commonPasswordsFromRecords = records.compactMap(\.commonPassword)
            let recordIDs = commonPasswordsFromRecords.map(\.id)
            let filteredPasswordsFromCoreData = commonPasswordsFromCoreData.filter({ !recordIDs.contains($0.id) })
            let combinedPasswords = filteredPasswordsFromCoreData + commonPasswordsFromRecords
            let sortedPasswords = combinedPasswords
                .sortByUpdatedDateDescending()

            DispatchQueue.main.async { [weak self] in
                self?.passwords = sortedPasswords
                completion()
            }
        }
    }

    func savePassword(
        of password: String,
        withName name: String,
        destination: CommonPassword.Source,
        completion: @escaping (Bool) -> Void) {
            var unwrappedName: String? = name
            if name.replacingOccurrences(of: " ", with: "").isEmpty {
                unwrappedName = nil
            }

            CommonPassword.insert(
                args: .init(name: unwrappedName, value: password, source: destination),
                context: persistenceController.context!) { result in
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        let savedPassword: CommonPassword
                        switch result {
                        case .failure(let failure):
                            switch failure {
                            case .contextNotFound: console.error(Date(), failure)
                            case .coreDataError(error: let error): console.error(Date(), error)
                            case .cloudKitError(error: let error): console.error(Date(), error)
                            }
                            completion(false)
                            return
                        case .success(let success): savedPassword = success
                        }

                        self.passwords = self.passwords
                            .prepended(savedPassword)
                            .sortByUpdatedDateDescending()
                        completion(true)
                    }
                }
    }

    private func passwordToDeleteIDDidSet() {
        if passwordToDeleteID != nil {
            deletionAlertIsActive = true
        } else {
            deletionAlertIsActive = false
        }
    }

}
