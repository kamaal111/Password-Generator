//
//  CorePassword+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 08/09/2021.
//

import Foundation
import CoreData

extension CorePassword {
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
