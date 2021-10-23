//
//  SavedPasswordListItem.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 10/09/2021.
//

import SwiftUI
import SalmonUI
import PGLocale

struct SavedPasswordListItem: View {
    #if os(macOS)
    @State private var isHovering = false
    @State private var isDeleting = false
    #endif

    let password: CommonPassword
    let hasBeenLastCopied: Bool
    let editMode: EditMode
    let onPress: () -> Void
    let onDelete: () -> Void

    var body: some View {
        #if os(macOS)
        KDeletableView(
            isDeleting: $isDeleting,
            enabled: editMode.isEditing,
            deleteText: PGLocale.Keys.DELETE.localized,
            onDelete: onDelete) {
                Button(action: onPress) {
                    buttonInnerView
                        .padding(.top, 1)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(isHovering ? .accentColor : .primary)
                .onHover(perform: { hovering in
                    isHovering = hovering
                })
            }
        #else
        Button(action: onPress) {
            buttonInnerView
        }
        #endif
    }

    private var buttonInnerView: some View {
        HStack {
            Text(displayText)
                .bold()
            Spacer()
            if hasBeenLastCopied {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
    }

    private var displayText: String {
        password.name ?? Self.dateFormatter.string(from: password.creationDate)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

// struct SavedPasswordListItem_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedPasswordListItem(password: , onPress: { })
//    }
// }
