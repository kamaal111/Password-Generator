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
    @State private var syncingIsEnabled = false

    @Binding var name: String
    @Binding var destination: CommonPassword.Source

    let onCommit: () -> Void
    let onClose: () -> Void

    var body: some View {
        KSheetStack(
            leadingNavigationButton: { leadingNavigationButton },
            trailingNavigationButton: { trailingNavigationButton }) {
                VStack {
                    KFloatingTextField(
                        text: $name,
                        title: PGLocale.Keys.NAME.localized,
                        textFieldType: .text,
                        onCommit: onCommit)
                    Toggle(isOn: $syncingIsEnabled) {
                        Text(localized: .SYNC_WITH_ICLOUD)
                    }
                }
                .padding(.top, .medium)
            }
            .onAppear(perform: {
                switch destination {
                case .coreData: syncingIsEnabled = false
                case .iCloud: syncingIsEnabled = true
                }
            })
            .onChange(of: syncingIsEnabled, perform: { newValue in
                if newValue {
                    destination = .iCloud
                } else {
                    destination = .coreData
                }
            })
            #if os(macOS)
            .frame(minWidth: 300, minHeight: 128)
            #endif
    }

    private var leadingNavigationButton: some View {
        Button(action: onClose) {
            Text(localized: .CLOSE)
                .bold()
        }
    }

    private var trailingNavigationButton: some View {
        Button(action: onCommit) {
            Text(localized: .SAVE)
                .bold()
        }
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
