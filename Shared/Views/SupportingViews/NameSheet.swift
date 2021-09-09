//
//  NameSheet.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 09/09/2021.
//

import SwiftUI
import SalmonUI
import PGLocale

struct NameSheet: View {
    @Binding var name: String

    let onCommit: () -> Void
    let onClose: () -> Void

    var body: some View {
        KSheetStack(leadingNavigationButton: {
            Button(action: onCommit) {
                Text(localized: .SAVE)
            }
        }, trailingNavigationButton: {
            Button(action: onClose) {
                Text(localized: .CLOSE)
            }
        }) {
            VStack {
                KFloatingTextField(
                    text: $name,
                    title: PGLocale.Keys.NAME.localized,
                    textFieldType: .text,
                    onCommit: onCommit)
            }
            .padding(.top, .medium)
        }
        .frame(minHeight: 128)
    }
}

struct NameSheet_Previews: PreviewProvider {
    static var previews: some View {
        NameSheet(name: .constant("Super site"), onCommit: { }, onClose: { })
    }
}
