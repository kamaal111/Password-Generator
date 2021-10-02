//
//  LogoPlaygroundToggle.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 02/10/2021.
//

import SwiftUI

struct LogoPlaygroundToggle: View {
    @Binding var value: Bool

    let text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
            Divider()
            Toggle(value ? "Yup" : "Nope", isOn: $value)
        }
    }
}

struct LogoPlaygroundToggle_Previews: PreviewProvider {
    static var previews: some View {
        LogoPlaygroundToggle(value: .constant(true), text: "Toggling")
    }
}
