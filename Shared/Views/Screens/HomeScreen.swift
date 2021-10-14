//
//  HomeScreen.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI
import SalmonUI

struct HomeScreen: View {
    @EnvironmentObject
    private var coreDataModel: CoreDataModel

    @StateObject
    private var viewModel = ViewModel()
    @StateObject
    private var stackNavigator = StackNavigator(registeredScreens: Self.registeredScreens)

    var body: some View {
        VerticalForm {
            KSpacedHStack(left: {
                Text(localized: .LENGTH_LABEL)
            }, right: {
                Stepper("\(viewModel.letterLength)", value: $viewModel.letterLength, in: Constants.passwordLengthRange)
                    .accessibility(identifier: "password-length-stepper")
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
                .ktakeWidthEagerly()
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
                title: Text(localized: .DUPLICATE_PASSWORDS),
                message: Text(localized: .DUPLICATE_PASSWORDS_MESSAGE),
                primaryButton: .default(Text(localized: .SURE), action: savePassword),
                secondaryButton: .cancel())
        }
        .onChange(of: viewModel.currentPassword) { changedCurrentPassword in
            guard let changedCurrentPassword = changedCurrentPassword else { return }
            coreDataModel.setLastGeneratedPassword(with: changedCurrentPassword)
        }
        .onShake(perform: {
            #if DEBUG
            stackNavigator.navigate(to: .playground)
            #endif
        })
        .withNavigationPoints(selectedScreen: $stackNavigator.selectedScreen, stackNavigator: stackNavigator)
    }

    private func savePassword() {
        let success = coreDataModel.savePassword(
            of: viewModel.passwordLabel,
            withName: viewModel.passwordName)
        viewModel.onPasswordSave(success: success)
    }

    #if DEBUG
    private static let registeredScreens: [StackNavigator.Screens] = [.playground]
    #else
    private static let registeredScreens: [StackNavigator.Screens] = []
    #endif
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
