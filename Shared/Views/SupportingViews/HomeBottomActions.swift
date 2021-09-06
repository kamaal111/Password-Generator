//
//  HomeBottomActions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 06/09/2021.
//

import SwiftUI

struct HomeBottomActions: View {
    let generateButtonIsEnabled: Bool
    let showSaveButton: Bool
    let generatePassword: () -> Void
    let savePassword: () -> Void

    var body: some View {
        #if os(macOS)
        HStack {
            Button(action: generatePassword) {
                Text(localized: .GENERATE_BUTTON)
            }
            .disabled(!generateButtonIsEnabled)
            if showSaveButton {
                Button(action: savePassword) {
                    Text(localized: .SAVE)
                }
            }
        }
        #else
        VStack {
            Button(action: generatePassword) {
                Text(localized: .GENERATE_BUTTON)
                    .takeWidthEagerly()
            }
            .disabled(!generateButtonIsEnabled)
            if showSaveButton {
                Button(action: savePassword) {
                    Text(localized: .SAVE)
                        .takeWidthEagerly()
                }
            }
        }
        #endif
    }
}

struct HomeBottomActions_Previews: PreviewProvider {
    static var previews: some View {
        HomeBottomActions(generateButtonIsEnabled: true, showSaveButton: true, generatePassword: { }, savePassword: { })
    }
}
