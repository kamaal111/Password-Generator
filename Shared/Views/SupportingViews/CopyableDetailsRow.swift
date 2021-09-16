//
//  CopyableDetailsRow.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 15/09/2021.
//

import SwiftUI
import PGLocale

struct CopyableDetailsRow: View {
    @Binding var showPassword: Bool

    let label: String
    let value: String
    let showCopyButton: Bool
    let showShowPasswordButton: Bool
    let onCopyPress: () -> Void

    init(
        showPassword: Binding<Bool>,
        label: String,
        value: String,
        showCopyButton: Bool,
        showShowPasswordButton: Bool,
        onCopyPress: @escaping () -> Void) {
        self._showPassword = showPassword
        self.label = label
        self.value = value
        self.showCopyButton = showCopyButton
        self.showShowPasswordButton = showShowPasswordButton
        self.onCopyPress = onCopyPress
    }

    init(
        showPassword: Binding<Bool>,
        label: PGLocale.Keys,
        value: String,
        showCopyButton: Bool,
        showShowPasswordButton: Bool,
        onCopyPress: @escaping () -> Void) {
        self.init(
            showPassword: showPassword,
            label: label.localized,
            value: value,
            showCopyButton: showCopyButton,
            showShowPasswordButton: showShowPasswordButton,
            onCopyPress: onCopyPress)
    }

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
            Text(value)
                .multilineTextAlignment(.center)
            Spacer()
            if showCopyButton {
                Button(action: onCopyPress) {
                    Image(systemName: "doc.on.clipboard.fill")
                }
            }
            if showShowPasswordButton {
                Button(action: {
                    withAnimation { showPassword.toggle() }
                }) {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                }
            }
        }
    }
}

struct CopyableDetailsRow_Previews: PreviewProvider {
    static var previews: some View {
        CopyableDetailsRow(
            showPassword: .constant(false),
            label: "Label:",
            value: "Value",
            showCopyButton: true,
            showShowPasswordButton: true,
            onCopyPress: { })
    }
}
