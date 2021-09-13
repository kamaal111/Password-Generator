//
//  SavedPasswordListItem.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 10/09/2021.
//

import SwiftUI

struct SavedPasswordListItem: View {
    #if os(macOS)
    @State private var isHovering = false
    #endif

    let password: CorePassword
    let hasBeenLastCopied: Bool
    let onPress: () -> Void

    var body: some View {
        #if os(macOS)
        Button(action: onPress) {
            buttonInnerView
                .padding(.top, 1)
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(isHovering ? .accentColor : .primary)
        .onHover(perform: { hovering in
            isHovering = hovering
        })
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
