//
//  HomeScreen.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI

struct HomeScreen: View {
    @State private var lengthPicker = 16

    var body: some View {
        #if os(macOS)
        VStack {
            lengthView
        }
        .padding(.horizontal, .medium)
        .takeSizeEagerly(alignment: .topLeading)
        .navigationTitle(Text(Constants.appName))
        #elseif os(iOS)
        Form {
            lengthView
        }
        .navigationTitle(Text(Constants.appName))
        #endif
    }

    private var lengthView: some View {
        HStack {
            Text("Length:")
            Spacer()
            Stepper("\(lengthPicker)", value: $lengthPicker, in: 1...256)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
