//
//  CommonPassword.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 23/10/2021.
//

import Foundation
import CoreData
import ConsoleSwift

struct CommonPassword: Hashable, Identifiable {
    let id: UUID
    let name: String?
    let creationDate: Date
    let updatedDate: Date
    let value: String
    let source: Source

    enum Source {
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

    enum DeletionErrors: Error {
        case contextNotFound
        case coreDataError(error: Error)
        case coreDataValueNotFound
        case cloudKitError(error: Error)
    }

    var maskedValue: String {
        value.map({ _ in "*" }).joined()
    }

    var toCloudKitItem: CKRecord {
        let record = CKRecord(recordType: CorePassword.recordType)
        record[RecordKeys.name.rawValue] = name
        record[RecordKeys.value.rawValue] = value.nsString
        record[RecordKeys.id.rawValue] = id.nsString
        record[RecordKeys.updatedDate.rawValue] = updatedDate
        record[RecordKeys.creationDate.rawValue] = creationDate
        return record
    }

    func delete(context: NSManagedObjectContext? = nil, completion: @escaping (Result<Void, DeletionErrors>) -> Void) {
        switch source {
        case .coreData:
            completion(deleteCoreDataItem(context: context))
            return
        case .iCloud:
            deleteCloudKitItem(completion: completion)
            return
        }
    }

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

    private func deleteCoreDataItem(context: NSManagedObjectContext?) -> Result<Void, DeletionErrors> {
        guard let context = context else { return .failure(.contextNotFound) }

        let coreDataItem: CorePassword
        switch toCoreDataItem(context: context) {
        case .failure(let failure):
            return .failure(.coreDataError(error: failure))
        case .success(let success):
            guard let success = success else { return .failure(.coreDataValueNotFound) }
            coreDataItem = success
        }

        context.delete(coreDataItem)
        do {
            try context.save()
        } catch {
            return .failure(.coreDataError(error: error))
        }

        return .success(Void())
    }

    private func deleteCloudKitItem(completion: @escaping (Result<Void, DeletionErrors>) -> Void) {
        CloudKitController.shared.delete(toCloudKitItem) { result in
            switch result {
            case .failure(let failure):
                completion(.failure(.cloudKitError(error: failure)))
                return
            case .success(_): break
            }

            completion(.success(Void()))
        }
    }

    struct Args {
        let name: String?
        let value: String

        init(name: String?, value: String) {
            self.name = name
            self.value = value
        }

        init(value: String) {
            self.init(name: nil, value: value)
        }
    }
}
