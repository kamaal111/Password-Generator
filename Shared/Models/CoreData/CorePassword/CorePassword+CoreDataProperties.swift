//
//  CorePassword+CoreDataProperties.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 06/09/2021.
//
//

import Foundation
import CoreData


extension CorePassword {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CorePassword> {
        return NSFetchRequest<CorePassword>(entityName: "CorePassword")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String?
    @NSManaged public var creationDate: Date
    @NSManaged public var updatedDate: Date
    @NSManaged public var value: String

}

extension CorePassword : Identifiable {

}
