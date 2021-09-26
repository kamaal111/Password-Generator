//
//  FormHeader.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 26/09/2021.
//

import SwiftUI
import PGLocale

struct FormHeader: View {
    let title: String

    init(title: String) {
        self.title = title
    }

    init(title: PGLocale.Keys) {
        self.init(title: title.localized)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
            Divider()
        }
    }
}

struct FormHeader_Previews: PreviewProvider {
    static var previews: some View {
        FormHeader(title: "Titler")
    }
}
