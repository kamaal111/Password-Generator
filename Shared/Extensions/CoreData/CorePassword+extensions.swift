//
//  CorePassword+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 08/09/2021.
//

import Foundation
import CoreData

extension CorePassword {
    static let entityName = String(describing: CorePassword.self)

    static func saveNew(args: Args, context: NSManagedObjectContext) -> Result<CorePassword, Error> {
        let password = CorePassword(context: context)
        password.id = UUID()
        password.name = args.name
        password.value = args.value
        let now = Date()
        password.creationDate = now
        password.updatedDate = now
        do {
            try context.save()
        } catch {
            return .failure(error)
        }
        return .success(password)
    }

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
