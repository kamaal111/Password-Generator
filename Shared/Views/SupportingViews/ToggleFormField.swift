//
//  ToggleFormField.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI
import PGLocale
import SalmonUI

struct ToggleFormField: View {
    @Binding var value: Bool

    let text: String

    init(value: Binding<Bool>, text: String) {
        self._value = value
        self.text = text
    }

    init(value: Binding<Bool>, text: PGLocale.Keys) {
        self.init(value: value, text: text.localized)
    }

    var body: some View {
        KSpacedHStack(left: {
            Text(text)
        }, right: {
            Toggle("", isOn: $value)
        })
        .padding(.trailing, DeviceInfo.isMac ? -4 : 0)
    }
}

struct ToggleFormField_Previews: PreviewProvider {
    static var previews: some View {
        ToggleFormField(value: .constant(true), text: "Toggle Field")
    }
}
