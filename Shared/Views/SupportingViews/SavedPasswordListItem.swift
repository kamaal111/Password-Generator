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
        Button(action: onPress) {
            Text(displayText)
                .bold()
                .takeWidthEagerly(alignment: .leading)
                .padding(.top, 1)
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(isHovering ? .accentColor : .primary)
        .onHover(perform: { hovering in
            isHovering = hovering
        })
        #else
        Button(action: onPress) {
            Text(displayText)
                .bold()
        }
        #endif
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
