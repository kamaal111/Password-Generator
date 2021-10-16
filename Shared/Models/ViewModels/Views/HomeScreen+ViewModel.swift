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
            didSet { letterLengthDidSet() }
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
        @Published private(set) var currentPassword: String?
        @Published private var lastCopiedPassword: String?
        @Published private var lastSavedPassword: String?
        @Published var nameSheetIsShown = false
        @Published var passwordName = ""
        @Published var duplicatesExistAlertIsShown = false

        init() {
            if let userDefaultsLetterLength = UserDefaults.letterLength, !Config.isUITest {
                self.letterLength = userDefaultsLetterLength
            } else {
                self.letterLength = 16
            }
            self.lowercaseLettersEnabled = UserDefaults.lowercaseLettersEnabled ?? true
            self.capitalLettersEnabled = UserDefaults.capitalLettersEnabled ?? true
            self.numeralsEnabled = UserDefaults.numeralsEnabled ?? true
            self.symbolsEnabled = UserDefaults.symbolsEnabled ?? true

            setupObservers()
        }

        deinit {
            removeObservers()
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

        func showDuplicatesExistAlertIsShown() {
            duplicatesExistAlertIsShown = true
        }

        func openNameSheet() {
            nameSheetIsShown = true
        }

        func closeNameSheet(keepName: Bool) {
            nameSheetIsShown = false
            if !keepName {
                passwordName = ""
            }
        }

        func generatePassword() {
            let passwordHandler = PasswordHandler(
                enableLowers: lowercaseLettersEnabled,
                enableUppers: capitalLettersEnabled,
                enableNumerals: numeralsEnabled,
                enableSymbols: symbolsEnabled)
            withAnimation {
                currentPassword = passwordHandler.create(length: letterLength)
            }
        }

        func onPasswordSave(success: Bool) {
            guard success else { return }
            withAnimation {
                lastSavedPassword = currentPassword
                closeNameSheet(keepName: false)
            }
        }

        func copyPassword() {
            guard let currentPassword = self.currentPassword else { return }
            Clipboard.copy(currentPassword)
            withAnimation { lastCopiedPassword = currentPassword }
        }

        @objc
        private func handleCopyShortcutTriggeredNotification(_ notifcation: Notification? = nil) {
            guard let notificationPassword = notifcation?.object as? String,
                  notificationPassword == currentPassword else { return }
            copyPassword()
        }

        private func setupObservers() {
            #if os(macOS)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleCopyShortcutTriggeredNotification),
                name: .copyShortcutTriggered,
                object: nil)
            #endif
        }

        private func removeObservers() {
            #if os(macOS)
            NotificationCenter.default.removeObserver(self, name: .copyShortcutTriggered, object: nil)
            #endif
        }

        func letterLengthDidSet() {
            if !Config.isUITest {
                UserDefaults.letterLength = letterLength
            }
        }

    }
}
