//
//  SettingsFormToggle.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 23/10/2021.
//

import SwiftUI
import PGLocale

struct SettingsFormToggle: View {
    @Binding var state: Bool

    let label: String

    init(state: Binding<Bool>, label: String) {
        self._state = state
        self.label = label
    }

    init(state: Binding<Bool>, label: PGLocale.Keys) {
        self.init(state: state, label: label.localized)
    }

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Toggle("", isOn: $state)
                .labelsHidden()
        }
    }
}

struct SettingsFormToggle_Previews: PreviewProvider {
    static var previews: some View {
        SettingsFormToggle(state: .constant(true), label: "Thug")
    }
}
