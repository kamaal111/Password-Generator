//
//  PlaygroundFormButton.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 22/10/2021.
//

import SwiftUI

struct PlaygroundFormButton: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(.accentColor)
                .font(.headline)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PlaygroundFormButton_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundFormButton(text: "Texter", action: { })
    }
}
