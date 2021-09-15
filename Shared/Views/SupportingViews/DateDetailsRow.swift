//
//  DateDetailsRow.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 15/09/2021.
//

import SwiftUI
import PGLocale

struct DateDetailsRow: View {
    let label: String
    let dateString: String

    init(label: String, dateString: String) {
        self.label = label
        self.dateString = dateString
    }

    init(label: PGLocale.Keys, dateString: String) {
        self.init(label: label.localized, dateString: dateString)
    }

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
            Text(dateString)
                .font(.subheadline)
        }
        .foregroundColor(.secondary)
    }
}

struct DateDetailsRow_Previews: PreviewProvider {
    static var previews: some View {
        DateDetailsRow(label: "Label", dateString: "10/1/10")
    }
}
