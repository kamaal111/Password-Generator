//
//  HomeScreen.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject
    private var viewModel = ViewModel()

    var body: some View {
        #if os(macOS)
        view
            .padding(.all, .medium)
            .takeSizeEagerly(alignment: .topLeading)
            .navigationTitle(Text(Constants.appName))
        #elseif os(iOS)
        view
            .navigationTitle(Text(Constants.appName))
        #endif
    }

    private var view: some View {
        VerticalForm {
            SpacedHStack(left: {
                Text(localized: .LENGTH_LABEL)
            }, right: {
                Stepper("\(viewModel.lengthPicker)", value: $viewModel.lengthPicker, in: Constants.passwordLengthRange)
            })
            ToggleFormField(value: $viewModel.lowercaseLetters, text: .LOWERCASE_LETTERS)
            ToggleFormField(value: $viewModel.capitalLetters, text: .CAPITAL_LETTERS)
            #if os(macOS)
            Spacer()
            #endif
            Text(localized: .PASSWORD_PLACEHOLDER)
                .font(.headline)
                .takeWidthEagerly()
            Button(action: viewModel.generatePassword) {
                #if os(macOS)
                Text(localized: .GENERATE_BUTTON)
                #elseif os(iOS)
                Text(localized: .GENERATE_BUTTON)
                    .takeWidthEagerly()
                #endif
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
