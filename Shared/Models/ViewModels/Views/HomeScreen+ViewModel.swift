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

        @Published var lengthPicker: Int {
            didSet { UserDefaults.lengthPicker = lengthPicker }
        }
        @Published var lowercaseLetters: Bool {
            didSet { UserDefaults.lowercaseLetters = lowercaseLetters }
        }
        @Published var capitalLetters: Bool {
            didSet { UserDefaults.capitalLetters = capitalLetters }
        }
        @Published var numerals: Bool {
            didSet { UserDefaults.numerals = numerals }
        }
        @Published var currentPassword: String?

        init() {
            self.lengthPicker = UserDefaults.lengthPicker ?? 16
            self.lowercaseLetters = UserDefaults.lowercaseLetters ?? true
            self.capitalLetters = UserDefaults.capitalLetters ?? true
            self.numerals = UserDefaults.numerals ?? true
        }

        var generateButtonIsEnabled: Bool {
            lowercaseLetters || capitalLetters || numerals
        }

        var passwordLabel: String {
            currentPassword ?? PGLocale.Keys.PASSWORD_PLACEHOLDER.localized
        }

        func generatePassword() {
            let passwordHandler = PasswordHandler(
                enableLowers: lowercaseLetters,
                enableUppers: capitalLetters,
                enableNumerals: numerals)
            currentPassword = passwordHandler.create(length: lengthPicker)
        }

    }
}
