//
//  CommonPassword.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 23/10/2021.
//

import Foundation
import CoreData
import ConsoleSwift
import CloudKit

struct CommonPassword: Hashable, Identifiable {
    let id: UUID
    let name: String?
    let creationDate: Date
    let updatedDate: Date
    let value: String
    let source: Source

    enum Source: Codable, Hashable {
        case coreData
        case iCloud
    }

    enum RecordKeys: String, CaseIterable {
        case name
        case id
        case updatedDate = "updated_date"
        case creationDate = "creation_date"
        case value
    }

    var maskedValue: String {
        value.map({ _ in "*" }).joined()
    }

    var args: Args {
        .init(name: name, value: value, source: source)
    }

    struct Args {
        let name: String?
        let value: String
        let source: Source

        init(name: String?, value: String, source: Source) {
            self.name = name
            self.value = value
            self.source = source
        }

        init(value: String, source: Source) {
            self.init(name: nil, value: value, source: source)
        }
    }
}

extension Sequence where Element == CommonPassword {
    func sortByUpdatedDateDescending() -> [CommonPassword] {
        self.sorted(by: { password1, password2 in
            password1.updatedDate.compare(password2.updatedDate) == .orderedDescending
        })
    }
}

// - MARK: Insert

extension CommonPassword {
    enum InsertErrors: Error {
        case contextNotFound
        case coreDataError(error: Error)
        case cloudKitError(error: Error)
    }

    static func insert(
        args: Args,
        context: NSManagedObjectContext? = nil,
        completion: @escaping (Result<CommonPassword, InsertErrors>) -> Void) {
            switch args.source {
            case .coreData: completion(insertCoreDataItem(args: args, context: context))
            case .iCloud: insertCloudKitItem(args: args, completion: completion)
            }
    }

    private static  func insertCoreDataItem(
        args: Args,
        context: NSManagedObjectContext?) -> Result<CommonPassword, InsertErrors> {
            guard let context = context else { return .failure(.contextNotFound) }

            let savedPassword: CorePassword
            let saveNewResult = CorePassword.saveNew(args: .init(name: args.name, value: args.value), context: context)
            switch saveNewResult {
            case .failure(let failure): return .failure(.coreDataError(error: failure))
            case .success(let success): savedPassword = success
            }

            return .success(savedPassword.common)
    }

    private static func insertCloudKitItem(
        args: Args,
        completion: @escaping (Result<CommonPassword, InsertErrors>) -> Void) {
            let now = Date()
            let passwordToSave = CommonPassword(
                id: UUID(),
                name: args.name,
                creationDate: now,
                updatedDate: now,
                value: args.value,
                source: .iCloud)
            CloudKitController.shared.save(passwordToSave.toCloudKitItem()) { result in
                switch result {
                case .failure(let failure):
                    completion(.failure(.cloudKitError(error: failure)))
                    return
                case .success(_): break
                }

                completion(.success(passwordToSave))
            }
    }
}

// - MARK: Update

extension CommonPassword {
    enum UpdateErrors: Error {
        case contextNotFound
        case coreDataError(error: Error)
        case coreDataValueNotFound
        case cloudKitError(error: Error)
    }

    func update(
        args: Args,
        context: NSManagedObjectContext? = nil,
        completion: @escaping (Result<CommonPassword, UpdateErrors>) -> Void) {
            if args.source != source {
                #error("Handle source change")
            }
            switch source {
            case .coreData: completion(updateCoreDataItem(args: args, context: context))
            case .iCloud: updateCloudKitItem(args: args, completion: completion)
            }
        }

    private func updateCoreDataItem(
        args: Args,
        context: NSManagedObjectContext?) -> Result<CommonPassword, UpdateErrors> {
            guard let context = context else { return .failure(.contextNotFound) }

            let coreDataItem: CorePassword
            switch toCoreDataItem(context: context) {
            case .failure(let failure): return .failure(.coreDataError(error: failure))
            case .success(let success):
                guard let success = success else { return .failure(.coreDataValueNotFound) }
                coreDataItem = success
            }

            let editedPassword: CorePassword
            let editResult = coreDataItem.edit(args: .init(name: args.name, value: args.value))
            switch editResult {
            case .failure(let failure): return .failure(.coreDataError(error: failure))
            case .success(let success): editedPassword = success
            }

            return .success(editedPassword.common)
    }

    private func updateCloudKitItem(args: Args, completion: @escaping (Result<CommonPassword, UpdateErrors>) -> Void) {
        let editedPassword = CommonPassword(
            id: id,
            name: args.name,
            creationDate: creationDate,
            updatedDate: Date(),
            value: args.value,
            source: .iCloud)
        CloudKitController.shared.save(editedPassword.toCloudKitItem()) { result in
            switch result {
            case .failure(let failure):
                completion(.failure(.cloudKitError(error: failure)))
                return
            case .success(_): break
            }
            completion(.success(editedPassword))
        }
    }
}

// - MARK: Delete

extension CommonPassword {
    enum DeletionErrors: Error {
        case contextNotFound
        case coreDataError(error: Error)
        case coreDataValueNotFound
        case cloudKitError(error: Error)
    }

    func delete(context: NSManagedObjectContext? = nil, completion: @escaping (Result<Void, DeletionErrors>) -> Void) {
        switch source {
        case .coreData: completion(deleteCoreDataItem(context: context))
        case .iCloud: deleteCloudKitItem(completion: completion)
        }
    }

    private func deleteCoreDataItem(context: NSManagedObjectContext?) -> Result<Void, DeletionErrors> {
        guard let context = context else { return .failure(.contextNotFound) }

        let coreDataItem: CorePassword
        switch toCoreDataItem(context: context) {
        case .failure(let failure): return .failure(.coreDataError(error: failure))
        case .success(let success):
            guard let success = success else { return .failure(.coreDataValueNotFound) }
            coreDataItem = success
        }

        do {
            try coreDataItem.delete()
        } catch {
            return .failure(.coreDataError(error: error))
        }

        return .success(Void())
    }

    private func deleteCloudKitItem(completion: @escaping (Result<Void, DeletionErrors>) -> Void) {
        CloudKitController.shared.delete(toCloudKitItem()) { result in
            switch result {
            case .failure(let failure):
                completion(.failure(.cloudKitError(error: failure)))
                return
            case .success(_): break
            }

            completion(.success(Void()))
        }
    }
}

// - MARK: Cloud Kit methods

extension CommonPassword {
    func toCloudKitItem() -> CKRecord {
        let record = CKRecord(recordType: CorePassword.recordType)
        record[RecordKeys.name.rawValue] = name
        record[RecordKeys.value.rawValue] = value.nsString
        record[RecordKeys.id.rawValue] = id.nsString
        record[RecordKeys.updatedDate.rawValue] = updatedDate
        record[RecordKeys.creationDate.rawValue] = creationDate
        return record
    }
}

extension CKRecord {
    var commonPassword: CommonPassword? {
        guard let idString = self[CommonPassword.RecordKeys.id.rawValue] as? String,
                let id = UUID(uuidString: idString) else { return nil }
        guard let creationDate = self[CommonPassword.RecordKeys.creationDate.rawValue] as? Date else { return nil }
        guard let updatedDate = self[CommonPassword.RecordKeys.updatedDate.rawValue] as? Date else { return nil }
        guard let value =  self[CommonPassword.RecordKeys.value.rawValue] as? String else { return nil }
        let name = self[CommonPassword.RecordKeys.name.rawValue] as? String
        return .init(
            id: id,
            name: name,
            creationDate: creationDate,
            updatedDate: updatedDate,
            value: value,
            source: .iCloud)
    }
}

// - MARK: Core Data methods

extension CommonPassword {
    func toCoreDataItem(context: NSManagedObjectContext) -> Result<CorePassword?, Error> {
        let fetchRequest = NSFetchRequest<CorePassword>(entityName: CorePassword.entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.nsString)
        fetchRequest.fetchLimit = 1
        let fetchedPasswords: [CorePassword]
        do {
            fetchedPasswords = try context.fetch(fetchRequest)
        } catch {
            return .failure(error)
        }
        return .success(fetchedPasswords.first)
    }
}
