//
//  CopyableDetailsRow.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 15/09/2021.
//

import SwiftUI
import PGLocale
import SalmonUI

struct CopyableDetailsRow: View {
    @Binding var showValue: Bool
    @Binding var editValue: String

    let label: String
    let value: String
    let showCopyButton: Bool
    let showShowValueButton: Bool
    let editMode: EditMode
    let onCopyPress: () -> Void

    init(
        showValue: Binding<Bool>,
        editValue: Binding<String>,
        label: String,
        value: String,
        showCopyButton: Bool,
        showShowValueButton: Bool,
        editMode: EditMode,
        onCopyPress: @escaping () -> Void) {
        self._showValue = showValue
        self._editValue = editValue
        self.label = label
        self.value = value
        self.showCopyButton = showCopyButton
        self.showShowValueButton = showShowValueButton
        self.editMode = editMode
        self.onCopyPress = onCopyPress
    }

    init(
        showValue: Binding<Bool>,
        editValue: Binding<String>,
        label: PGLocale.Keys,
        value: String,
        showCopyButton: Bool,
        showShowValueButton: Bool,
        editMode: EditMode,
        onCopyPress: @escaping () -> Void) {
        self.init(
            showValue: showValue,
            editValue: editValue,
            label: label.localized,
            value: value,
            showCopyButton: showCopyButton,
            showShowValueButton: showShowValueButton,
            editMode: editMode,
            onCopyPress: onCopyPress)
    }

    var body: some View {
        HStack {
            if editMode.isEditing {
                if showShowValueButton {
                    SecureFloatingField(text: $editValue, title: label)
                } else {
                    KFloatingTextField(text: $editValue, title: label)
                }
            } else {
                Text(label)
                    .font(.headline)
                Text(value)
                    .multilineTextAlignment(.center)
            }
            Spacer()
            if !editMode.isEditing {
                if showShowValueButton {
                    Button(action: {
                        withAnimation { showValue.toggle() }
                    }) {
                        Image(systemName: showValue ? "eye.slash.fill" : "eye.fill")
                    }
                }
                if showCopyButton {
                    Button(action: onCopyPress) {
                        Image(systemName: "doc.on.clipboard.fill")
                    }
                }
            }
        }
    }
}

struct CopyableDetailsRow_Previews: PreviewProvider {
    static var previews: some View {
        CopyableDetailsRow(
            showValue: .constant(false),
            editValue: .constant("Edit Value"),
            label: "Label:",
            value: "Value",
            showCopyButton: true,
            showShowValueButton: true,
            editMode: .active,
            onCopyPress: { })
    }
}
