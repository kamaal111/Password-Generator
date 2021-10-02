//
//  LogoPlaygroundButton.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 02/10/2021.
//

#if DEBUG
import SwiftUI

struct LogoPlaygroundButton: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(.accentColor)
                .fontWeight(.semibold)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct LogoPlaygroundButton_Previews: PreviewProvider {
    static var previews: some View {
        LogoPlaygroundButton(text: "Texter", action: { })
    }
}
#endif
