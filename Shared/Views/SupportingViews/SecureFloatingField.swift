//
//  SecureFloatingField.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 16/09/2021.
//

import SwiftUI
import SalmonUI
import PGLocale

struct SecureFloatingField: View {
    @State private var showText = false

    @Binding var text: String

    let title: String

    init(text: Binding<String>, title: String) {
        self._text = text
        self.title = title
    }

    init(text: Binding<String>, title: PGLocale.Keys) {
        self.init(text: text, title: title.localized)
    }

    var body: some View {
        #if os(iOS)
        view
            .padding(.top, 12)
        #else
        view
        #endif
    }

    private var view: some View {
        HStack {
            #if os(iOS)
            textViews
                .padding(.top, 12)
            #else
            textViews
            #endif
            Button(action: { showText.toggle() }) {
                Image(systemName: showText ? "eye.fill" : "eye.slash.fill")
            }
        }
    }

    private var textViews: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(textColor)
                .offset(y: $text.wrappedValue.isEmpty ? 0 : -25)
                .scaleEffect($text.wrappedValue.isEmpty ? 1 : 0.75, anchor: .leading)
                .padding(.horizontal, titleHorizontalPadding)
            if showText {
                TextField(titleText, text: $text)
            } else {
                SecureField(titleText, text: $text)
            }
        }
        .padding(.top, 12)
        .animation(.spring(response: 0.5))
    }

    private var titleText: String {
        #if canImport(UIKit)
        ""
        #else
        title
        #endif
    }

    private var textColor: Color {
        if $text.wrappedValue.isEmpty {
            return .secondary
        }
        return .accentColor
    }

    private var titleHorizontalPadding: CGFloat {
        if $text.wrappedValue.isEmpty {
            return 4
        }
        return 0
    }
}

struct SecureFloatingField_Previews: PreviewProvider {
    static var previews: some View {
        SecureFloatingField(text: .constant("yes"), title: "secure")
    }
}
