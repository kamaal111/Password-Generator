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
        @Published private(set) var editMode = EditMode.inactive
        @Published var edittedName = ""
        @Published var edittedPasswordValue = ""

        var creationDateString: String {
            passwordDateString(of: \.creationDate)
        }

        var updatedDateString: String {
            passwordDateString(of: \.updatedDate)
        }

        var navigationTitleString: String {
            password?.name ?? creationDateString
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

        func toggleEditMode() {
            guard let password = self.password else { return }
            if editMode.isEditing {
                /// - TODO: SAVE CHANGES
                withAnimation { [weak self] in
                    self?.editMode = .inactive
                }
            } else {
                withAnimation { [weak self] in
                    self?.setPassword(password)
                    self?.editMode = .active
                }
            }
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
            self.edittedName = password.name ?? ""
            self.edittedPasswordValue = password.value
        }

        private func passwordDateString(of keyPath: KeyPath<CorePassword, Date>) -> String {
            guard let password = self.password else { return "" }
            return Self.dateFormatter.string(from: password[keyPath: keyPath])
        }

        private static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter
        }()

    }
}
