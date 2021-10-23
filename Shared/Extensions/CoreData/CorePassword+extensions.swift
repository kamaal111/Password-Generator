//
//  CorePassword+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 08/09/2021.
//

import Foundation
import CoreData
import CloudKit

extension CorePassword {
    static let entityName = String(describing: CorePassword.self)

    // - TODO: CHECK IF NEEDED ELSE REMOVE
    var maskedValue: String {
        value.map({ _ in "*" }).joined()
    }

    var common: CommonPassword {
        CommonPassword(
            id: id,
            name: name,
            creationDate: creationDate,
            updatedDate: updatedDate,
            value: value,
            source: .coreData)
    }
}

// - MARK: Core Data helpers

extension CorePassword {
    static func checkForDuplicatePasswords(_ password: String, context: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest<CorePassword>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "value == %@", password)
        let fetchedPasswords: [CorePassword]
        do {
            fetchedPasswords = try context.fetch(fetchRequest)
        } catch {
            return false
        }
        return !fetchedPasswords.isEmpty
    }

    static func fetchAllPasswords(context: NSManagedObjectContext) -> Result<[CorePassword], Error> {
        let fetchRequest = NSFetchRequest<CorePassword>(entityName: entityName)
        let fetchedPasswords: [CorePassword]
        do {
            fetchedPasswords = try context.fetch(fetchRequest)
        } catch {
            return .failure(error)
        }
        return .success(fetchedPasswords)
    }
}

// - MARK: Core Data modifications

extension CorePassword {
    func edit(args: Args) -> Result<CorePassword, Error> {
        self.name = args.name
        self.value = args.value
        self.updatedDate = Date()
        do {
            try managedObjectContext?.save()
        } catch {
            return .failure(error)
        }
        return .success(self)
    }

    @discardableResult
    static func saveNew(args: Args, context: NSManagedObjectContext, save: Bool = true) -> Result<CorePassword, Error> {
        let password = CorePassword(context: context)
        password.id = UUID()
        password.name = args.name
        password.value = args.value
        let now = Date()
        password.creationDate = now
        password.updatedDate = now
        if save {
            do {
                try context.save()
            } catch {
                return .failure(error)
            }
        }
        return .success(password)
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

// - MARK: Cloud helpers

extension CorePassword {
    static let recordType = String(describing: CorePassword.self)

    enum RecordKeys: String, CaseIterable {
        case name
        case id
        case updatedDate = "updated_date"
        case creationDate = "creation_date"
        case value
    }

    var ckRecord: CKRecord {
        let record = CKRecord(recordType: Self.recordType)
        record[RecordKeys.name.rawValue] = name
        record[RecordKeys.value.rawValue] = value.nsString
        record[RecordKeys.id.rawValue] = id.nsString
        record[RecordKeys.updatedDate.rawValue] = updatedDate
        record[RecordKeys.creationDate.rawValue] = creationDate
        return record
    }

    func ckRecord(from record: CKRecord) -> CKRecord {
        let currentRecord = ckRecord
        let recordToUpdate = record
        RecordKeys.allCases.forEach { recordKey in
            recordToUpdate[recordKey.rawValue] = currentRecord[recordKey.rawValue]
        }
        return recordToUpdate
    }
}
