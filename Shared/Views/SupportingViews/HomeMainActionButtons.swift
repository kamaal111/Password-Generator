//
//  HomeMainActionButtons.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 07/09/2021.
//

import SwiftUI

struct HomeMainActionButtons: View {
    let showSaveAndCopyButton: Bool
    let generateButtonIsEnabled: Bool
    let hasCopiedPassword: Bool
    let copyPassword: () -> Void
    let generatePassword: () -> Void
    let savePassword: () -> Void

    var body: some View {
        #if os(macOS)
        HStack {
            if showSaveAndCopyButton {
                Button(action: copyPassword) {
                    HStack {
                        Text(localized: .COPY)
                        if hasCopiedPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            Button(action: generatePassword) {
                Text(localized: .GENERATE_BUTTON)
            }
            .disabled(!generateButtonIsEnabled)
            if showSaveAndCopyButton {
                Button(action: savePassword) {
                    Text(localized: .SAVE)
                }
            }
        }
        #else
        JustStack {
            if showSaveAndCopyButton {
                Button(action: copyPassword) {
                    HStack {
                        Text(localized: .COPY)
                            .takeWidthEagerly()
                        if hasCopiedPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            Button(action: generatePassword) {
                Text(localized: .GENERATE_BUTTON)
                    .takeWidthEagerly()
            }
            .disabled(!generateButtonIsEnabled)
            if showSaveAndCopyButton {
                Button(action: savePassword) {
                    Text(localized: .SAVE)
                        .takeWidthEagerly()
                }
            }
        }
        #endif
    }
}

struct HomeMainActionButtons_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainActionButtons(
            showSaveAndCopyButton: true,
            generateButtonIsEnabled: true,
            hasCopiedPassword: false,
            copyPassword: { },
            generatePassword: { },
            savePassword: { })
    }
}
