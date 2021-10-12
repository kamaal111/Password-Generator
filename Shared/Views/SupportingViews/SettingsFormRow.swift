//
//  SettingsFormRow.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 12/10/2021.
//

import SwiftUI
import PGLocale

struct SettingsFormRow: View {
    let label: String
    let value: String

    init(label: String, value: String) {
        self.label = label
        self.value = value
    }

    init(label: PGLocale.Keys, value: String) {
        self.init(label: label.localized, value: value)
    }

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
        }
    }
}

struct SettingsFormRow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsFormRow(label: "Label", value: "value")
    }
}
