//
//  SavedPasswordDetailScreen+ViewModel.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 15/09/2021.
//

import SwiftUI
import PGLocale

extension SavedPasswordDetailScreen {
    final class ViewModel: ObservableObject {

        @Published private var password: CorePassword?
        @Published var showPassword = false

        var navigationTitleString: String {
            password?.name ?? Self.dateFormatter.string(from: password?.creationDate ?? Date())
        }

        var passwordNameLabel: String {
            password?.name ?? PGLocale.Keys.NAME_NOT_DEFINED.localized
        }

        var showCopyNameButton: Bool {
            password?.name != nil
        }

        var passwordLabel: String {
            guard let password = self.password else { return "" }
            if showPassword {
                return password.value
            }
            return password.maskedValue
        }

        func toggleShowPassword() {
            withAnimation { [weak self] in
                self?.showPassword.toggle()
            }
        }

        func copyPassword() {
            guard let password = self.password else { return }
            Clipboard.copy(password.value)
        }

        func copyName() {
            guard let password = self.password, let name = password.name else { return }
            Clipboard.copy(name)
        }

        func setPassword(_ password: CorePassword) {
            self.password = password
        }

        private static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter
        }()

    }
}
