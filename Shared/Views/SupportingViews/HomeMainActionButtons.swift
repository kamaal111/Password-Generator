//
//  HomeMainActionButtons.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 07/09/2021.
//

import SwiftUI
import SalmonUI

struct HomeMainActionButtons: View {
    let showSaveAndCopyButton: Bool
    let generateButtonIsEnabled: Bool
    let hasCopiedPassword: Bool
    let hasSavedPassword: Bool
    let copyPassword: () -> Void
    let generatePassword: () -> Void
    let savePassword: () -> Void

    var body: some View {
        #if os(macOS)
        HStack {
            if showSaveAndCopyButton {
                CheckButton(text: .COPY, check: hasCopiedPassword, action: copyPassword)
            }
            Button(action: generatePassword) {
                Text(localized: .GENERATE_BUTTON)
            }
            .disabled(!generateButtonIsEnabled)
            if showSaveAndCopyButton {
                CheckButton(text: .SAVE, check: hasSavedPassword, action: savePassword)
                    .disabled(hasSavedPassword)
            }
        }
        #else
        KJustStack {
            if showSaveAndCopyButton {
                CheckButton(text: .COPY, check: hasCopiedPassword, action: copyPassword)
            }
            Button(action: generatePassword) {
                Text(localized: .GENERATE_BUTTON)
                    .takeWidthEagerly()
            }
            .disabled(!generateButtonIsEnabled)
            if showSaveAndCopyButton {
                CheckButton(text: .SAVE, check: hasSavedPassword, action: savePassword)
                    .disabled(hasSavedPassword)
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
            hasSavedPassword: true,
            copyPassword: { },
            generatePassword: { },
            savePassword: { })
    }
}
