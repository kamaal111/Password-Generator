//
//  EditMode.swift
//  Password-Generator (macOS)
//
//  Created by Kamaal Farah on 16/09/2021.
//

import Foundation

enum EditMode {
    case active
    case inactive

    var isEditing: Bool {
        self == .active
    }
}
