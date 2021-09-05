//
//  SpacedHStack.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI

struct SpacedHStack<Left: View, Right: View>: View {
    let left: () -> Left
    let right: () -> Right

    var body: some View {
        HStack {
            left()
            Spacer()
            right()
        }
    }
}

struct SpacedHStack_Previews: PreviewProvider {
    static var previews: some View {
        SpacedHStack(left: {
            Text("Left")
        }, right: {
            Text("Right")
        })
    }
}
