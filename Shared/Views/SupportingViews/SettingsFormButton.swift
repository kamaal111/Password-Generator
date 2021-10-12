//
//  SettingsFormButton.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 12/10/2021.
//

import SwiftUI
import PGLocale

struct SettingsFormButton: View {
    let title: String
    let imageSystemName: String
    let action: () -> Void

    init(title: String, imageSystemName: String, action: @escaping () -> Void) {
        self.title = title
        self.imageSystemName = imageSystemName
        self.action = action
    }

    init(title: PGLocale.Keys, imageSystemName: String, action: @escaping () -> Void) {
        self.init(title: title.localized, imageSystemName: imageSystemName, action: action)
    }

    var body: some View {
        #if os(macOS)
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: imageSystemName)
            }
            .padding(.vertical, .small)
            .padding(.horizontal, .medium)
            .background(Color(NSColor.separatorColor))
            .foregroundColor(.accentColor)
            .cornerRadius(.small)
        }
        .buttonStyle(PlainButtonStyle())
        #else
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.body)
                Spacer()
                Image(systemName: imageSystemName)
                    .size(.squared(AppSizes.medium.rawValue))
            }
        }
        #endif
    }
}

struct SettingsFormButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingsFormButton(title: "Title", imageSystemName: "plus", action: { })
    }
}
