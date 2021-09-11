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
    let onPress: () -> Void

    var body: some View {
        #if os(macOS)
        contextMenuWrappedView(Button(action: onPress) {
            Text(displayText)
                .bold()
                .takeWidthEagerly(alignment: .leading)
                .padding(.vertical, 2)
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(isHovering ? .accentColor : .primary)
        .onHover(perform: { hovering in
            isHovering = hovering
        }))
        #else
        contextMenuWrappedView(Button(action: onPress) {
            Text(displayText)
                .bold()
        })
        #endif
    }

    private var displayText: String {
        password.name ?? Self.dateFormatter.string(from: password.creationDate)
    }

    private func contextMenuWrappedView<V: View>(_ view: V) -> some View {
        view
            .contextMenu {
                Button(action: { print("copy password", password) }) {
                    Text(localized: .COPY_PASSWORD)
                }
                Button(action: { print("copy name", password) }) {
                    Text(localized: .COPY_NAME)
                }
            }
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
