//
//  CommonPassword.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 23/10/2021.
//

import Foundation
import CoreData

// - TODO: Render this everywhere
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

    var maskedValue: String {
        value.map({ _ in "*" }).joined()
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

    var toCloudKitItem: CKRecord {
        let record = CKRecord(recordType: CorePassword.recordType)
        record[RecordKeys.name.rawValue] = name
        record[RecordKeys.value.rawValue] = value.nsString
        record[RecordKeys.id.rawValue] = id.nsString
        record[RecordKeys.updatedDate.rawValue] = updatedDate
        record[RecordKeys.creationDate.rawValue] = creationDate
        return record
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
