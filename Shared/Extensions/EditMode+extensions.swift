//
//  EditMode+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 03/10/2021.
//

import SwiftUI

extension EditMode {
    mutating func toggle() {
        self = toggled()
    }

    func toggled() -> EditMode {
        if isEditing {
            return .inactive
        }
        return .active
    }
}
