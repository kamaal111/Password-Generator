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
            Text(password.value)
                .bold()
                .takeWidthEagerly(alignment: .leading)
                .padding(.vertical, 2)
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(isHovering ? .accentColor : .primary)
        .onHover(perform: { hovering in
            isHovering = hovering
        })
        #else
        Button(action: onPress) {
            Text(password.value)
                .bold()
        }
        #endif
    }
}

// struct SavedPasswordListItem_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedPasswordListItem(password: , onPress: { })
//    }
// }
