//
//  Text+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI
import PGLocale

extension Text {
    init(localized: PGLocale.Keys) {
        self.init(localized.localized)
    }
}
