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
                Stepper("\(viewModel.letterLength)", value: $viewModel.letterLength, in: Constants.passwordLengthRange)
            })
            ToggleFormField(value: $viewModel.lowercaseLettersEnabled, text: .LOWERCASE_LETTERS)
            ToggleFormField(value: $viewModel.capitalLettersEnabled, text: .CAPITAL_LETTERS)
            ToggleFormField(value: $viewModel.numeralsEnabled, text: .NUMERALS)
            ToggleFormField(value: $viewModel.symbolsEnabled, text: .SYMBOLS)
            #if os(macOS)
            Spacer()
            #endif
            Text(viewModel.passwordLabel)
                .font(.headline)
                .takeWidthEagerly()
                .multilineTextAlignment(.center)
            HomeMainActionButtons(
                showSaveAndCopyButton: viewModel.showSaveAndCopyButton,
                generateButtonIsEnabled: viewModel.generateButtonIsEnabled,
                copyPassword: viewModel.copyPassword,
                generatePassword: viewModel.generatePassword,
                savePassword: viewModel.savePassword)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
