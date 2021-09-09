//
//  HomeScreen.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject
    private var coreDataModel: CoreDataModel

    @StateObject
    private var viewModel = ViewModel()

    var body: some View {
        #if os(macOS)
        view
            .padding(.all, .medium)
            .takeSizeEagerly(alignment: .topLeading)
        #elseif os(iOS)
        view
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
                hasCopiedPassword: viewModel.hasCopiedPassword,
                hasSavedPassword: viewModel.hasSavedPassword,
                copyPassword: viewModel.copyPassword,
                generatePassword: viewModel.generatePassword,
                savePassword: viewModel.openNameSheet)
        }
        .navigationTitle(Text(Constants.appName))
        .sheet(isPresented: $viewModel.nameSheetIsShown) {
            NameSheet(name: $viewModel.passwordName, onCommit: {
                let duplicateExists = coreDataModel.checkForDuplicates(viewModel.passwordLabel)
                if !duplicateExists {
                    savePassword()
                } else {
                    viewModel.closeNameSheet(keepName: true)
                    viewModel.showDuplicatesExistAlertIsShown()
                }
            }, onClose: { viewModel.closeNameSheet(keepName: false) })
        }
        .alert(isPresented: $viewModel.duplicatesExistAlertIsShown) {
            Alert(
                title: Text("Duplicate password"),
                message: Text("Looks like you are trying to save a password that already has been saved, save anyway?"),
                primaryButton: .default(Text("Sure"), action: savePassword),
                secondaryButton: .cancel())
        }
    }

    private func savePassword() {
        let success = coreDataModel.savePassword(
            of: viewModel.passwordLabel,
            withName: viewModel.passwordName)
        viewModel.onPasswordSave(success: success)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
