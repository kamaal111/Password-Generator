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
        @Published private var lastCopiedPassword: String?
        @Published private var lastSavedPassword: String?
        @Published var nameSheetIsShown = false
        @Published var passwordName = ""

        init() {
            self.letterLength = UserDefaults.letterLength ?? 16
            self.lowercaseLettersEnabled = UserDefaults.lowercaseLettersEnabled ?? true
            self.capitalLettersEnabled = UserDefaults.capitalLettersEnabled ?? true
            self.numeralsEnabled = UserDefaults.numeralsEnabled ?? true
            self.symbolsEnabled = UserDefaults.symbolsEnabled ?? true
        }

        var hasCopiedPassword: Bool {
            guard let lastCopiedPassword = self.lastCopiedPassword else { return false }
            return lastCopiedPassword == currentPassword
        }

        var hasSavedPassword: Bool {
            guard let lastSavedPassword = self.lastSavedPassword else { return false }
            return lastSavedPassword == currentPassword
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

        func openNameSheet() {
            nameSheetIsShown = true
        }

        func closeNameSheet() {
            nameSheetIsShown = false
            passwordName = ""
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

        func onPasswordSave(success: Bool) {
            guard success else { return }
            withAnimation { [weak self] in
                guard let self = self else { return }
                self.lastSavedPassword = currentPassword
                self.closeNameSheet()
            }
        }

        func copyPassword() {
            guard let currentPassword = self.currentPassword, !hasCopiedPassword else { return }
            #if os(macOS)
            let pastboard = NSPasteboard.general
            pastboard.clearContents()
            pastboard.setString(currentPassword, forType: .string)
            #else
            let pastboard = UIPasteboard.general
            pastboard.string = currentPassword
            #endif
            withAnimation { [weak self] in
                self?.lastCopiedPassword = currentPassword
            }
        }

    }
}
