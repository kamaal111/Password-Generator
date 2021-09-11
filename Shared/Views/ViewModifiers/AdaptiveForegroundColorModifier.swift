//
//  AdaptiveForegroundColorModifier.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 11/09/2021.
//

import SwiftUI

private struct AdaptiveForegroundColorModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    var lightModeColor: Color
    var darkModeColor: Color

    func body(content: Content) -> some View {
        content.foregroundColor(resolvedColor)
    }

    private var resolvedColor: Color {
        switch colorScheme {
        case .light: return lightModeColor
        case .dark: return darkModeColor
        @unknown default: return lightModeColor
        }
    }
}

extension View {
    func foregroundColor(light lightModeColor: Color, dark darkModeColor: Color) -> some View {
        modifier(AdaptiveForegroundColorModifier(lightModeColor: lightModeColor, darkModeColor: darkModeColor))
    }
}
