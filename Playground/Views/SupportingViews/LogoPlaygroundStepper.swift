//
//  LogoPlaygroundStepper.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 02/10/2021.
//

import SwiftUI

struct LogoPlaygroundStepper<V: Strideable>: View {
    @Binding var value: V

    let text: String
    let stepperTitle: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
            Divider()
            Stepper(stepperTitle, value: $value)
        }
    }
}

struct LogoPlaygroundStepper_Previews: PreviewProvider {
    static var previews: some View {
        LogoPlaygroundStepper(value: .constant(22), text: "Steppin", stepperTitle: "22")
    }
}
