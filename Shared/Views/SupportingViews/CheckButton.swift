//
//  CheckButton.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 09/09/2021.
//

import SwiftUI
import PGLocale
import SalmonUI

struct CheckButton: View {
    let text: String
    let check: Bool
    let action: () -> Void

    init(text: String, check: Bool, action: @escaping () -> Void) {
        self.text = text
        self.check = check
        self.action = action
    }

    init(text: PGLocale.Keys, check: Bool, action: @escaping () -> Void) {
        self.init(text: text.localized, check: check, action: action)
    }

    var body: some View {
        #if os(macOS)
        Button(action: action) {
            HStack {
                Text(text)
                if check {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
        }
        #else
        Button(action: action) {
            HStack {
                Text(text)
                    .ktakeWidthEagerly()
                if check {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .accessibilityIdentifier("checkmark-\(text)")
                }
            }
        }
        #endif
    }
}

struct CheckButton_Previews: PreviewProvider {
    static var previews: some View {
        CheckButton(text: .COPY, check: true, action: { })
    }
}
