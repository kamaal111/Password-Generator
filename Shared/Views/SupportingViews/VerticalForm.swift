//
//  VerticalForm.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI

struct VerticalForm<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        #if os(iOS)
        Form {
            content
        }
        #elseif os(macOS)
        VStack {
            content
        }
        .padding(.all, .medium)
        .takeSizeEagerly(alignment: .topLeading)
        #endif
    }
}

struct VerticalForm_Previews: PreviewProvider {
    static var previews: some View {
        VerticalForm {
            Text("Yes")
            Text("Nope")
        }
    }
}
