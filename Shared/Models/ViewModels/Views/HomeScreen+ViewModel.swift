//
//  HomeScreen+ViewModel.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI
import PGLocale

extension HomeScreen {
    final class ViewModel: ObservableObject {

        @Published var letterLength: Int {
            didSet { UserDefaults.letterLength = letterLength }
        }
        @Published var lowercaseLettersEnabled: Bool {
            didSet { UserDefaults.lowercaseLettersEnabled = lowercaseLettersEnabled }
        }
        @Published var capitalLettersEnabled: Bool {
            didSet { UserDefaults.capitalLettersEnabled = capitalLettersEnabled }
        }
        @Published var numeralsEnabled: Bool {
            didSet { UserDefaults.numeralsEnabled = numeralsEnabled }
        }
        @Published var symbolsEnabled: Bool {
            didSet { UserDefaults.symbolsEnabled = symbolsEnabled }
        }
        @Published private var currentPassword: String?

        init() {
            self.letterLength = UserDefaults.letterLength ?? 16
            self.lowercaseLettersEnabled = UserDefaults.lowercaseLettersEnabled ?? true
            self.capitalLettersEnabled = UserDefaults.capitalLettersEnabled ?? true
            self.numeralsEnabled = UserDefaults.numeralsEnabled ?? true
            self.symbolsEnabled = UserDefaults.symbolsEnabled ?? true
        }

        var generateButtonIsEnabled: Bool {
            lowercaseLettersEnabled || capitalLettersEnabled || numeralsEnabled || symbolsEnabled
        }

        var passwordLabel: String {
            currentPassword ?? PGLocale.Keys.PASSWORD_PLACEHOLDER.localized
        }

        var showSaveAndCopyButton: Bool {
            currentPassword != nil
        }

        func generatePassword() {
            let passwordHandler = PasswordHandler(
                enableLowers: lowercaseLettersEnabled,
                enableUppers: capitalLettersEnabled,
                enableNumerals: numeralsEnabled,
                enableSymbols: symbolsEnabled)
            withAnimation { [weak self] in
                guard let self = self else { return }
                self.currentPassword = passwordHandler.create(length: self.letterLength)
            }
        }

        func savePassword() {
            print("saving")
        }

        func copyPassword() {
            print("copying")
        }

    }
}
