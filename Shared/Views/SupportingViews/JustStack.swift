//
//  JustStack.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 07/09/2021.
//

import SwiftUI

struct JustStack<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
    }
}

struct JustStack_Previews: PreviewProvider {
    static var previews: some View {
        JustStack {
            Text("1")
            Text("2")
            Text("3")
            Text("4")
            Text("5")
        }
    }
}
