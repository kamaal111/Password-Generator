//
//  CommonPassword.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 23/10/2021.
//

import Foundation

// - TODO: Render this everywhere
struct CommonPassword: Hashable, Identifiable {
    let id: UUID
    let name: String?
    let creationDate: Date
    let updatedDate: Date
    let value: String
    let source: Source

    enum Source {
        case iCloud
        case coreData
    }
}
