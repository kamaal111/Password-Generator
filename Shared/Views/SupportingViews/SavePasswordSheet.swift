//
//  SavePasswordSheet.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 09/09/2021.
//

import SwiftUI
import SalmonUI
import PGLocale

struct SavePasswordSheet: View {
    @Binding var name: String
    @Binding var destination: CommonPassword.Source

    let onCommit: () -> Void
    let onClose: () -> Void

    var body: some View {
        KSheetStack(leadingNavigationButton: {
            Button(action: onClose) {
                Text(localized: .CLOSE)
            }
        }, trailingNavigationButton: {
            Button(action: onCommit) {
                Text(localized: .SAVE)
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
        #if os(macOS)
        .frame(minWidth: 300, minHeight: 128)
        #endif
    }
}

struct SavePasswordSheet_Previews: PreviewProvider {
    static var previews: some View {
        SavePasswordSheet(
            name: .constant("Super site"),
            destination: .constant(.coreData),
            onCommit: { },
            onClose: { })
            .previewLayout(.sizeThatFits)
    }
}
