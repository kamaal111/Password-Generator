//
//  LoadingIndicator.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 30/10/2021.
//

import SwiftUI
import SalmonUI

struct LoadingIndicator: View {
    @Binding var loading: Bool

    var body: some View {
        #if os(macOS)
        KActivityIndicator(isAnimating: $loading, style: .spinning)
        #else
        KActivityIndicator(isAnimating: $loading, style: .large)
        #endif
    }
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator(loading: .constant(true))
    }
}
