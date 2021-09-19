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

        var editPasswordArgs: CorePassword.Args {
            var passwordName: String?
            if !edittedName.replacingOccurrences(of: " ", with: "").isEmpty {
                passwordName = edittedName
            }
            return CorePassword.Args(name: passwordName, value: edittedPasswordValue)
        }

        var passwordID: UUID? {
            password?.id
        }

        var passwordLabel: String {
            withUnwrappedPassword { password in
                if showPassword {
                    return password.value
                }
                return password.maskedValue
            } ?? ""
        }

        func toggleEditMode(onSave: (CorePassword.Args) -> Void) {
            withUnwrappedPassword { password in
                if editMode.isEditing {
                    onSave(editPasswordArgs)
                    withAnimation {
                        editMode = .inactive
                    }
                } else {
                    withAnimation {
                        setPassword(password)
                        editMode = .active
                    }
                }
            }
        }

        func cancelEditing() {
            withUnwrappedPassword { password in
                withAnimation {
                    setPassword(password)
                    editMode = .inactive
                }
            }
        }

        func toggleShowPassword() {
            withAnimation { showPassword.toggle() }
        }

        func copyPassword() {
            withUnwrappedPassword { password in
                Clipboard.copy(password.value)
            }
        }

        func copyName() {
            withUnwrappedPassword { password in
                guard let name = password.name else { return }
                Clipboard.copy(name)
            }
        }

        func setPassword(_ password: CorePassword) {
            self.password = password
            self.edittedName = password.name ?? ""
            self.edittedPasswordValue = password.value
        }

        private func passwordDateString(of keyPath: KeyPath<CorePassword, Date>) -> String {
            withUnwrappedPassword { password in
                Self.dateFormatter.string(from: password[keyPath: keyPath])
            } ?? ""
        }

        private func withUnwrappedPassword<T>(completion: (CorePassword) -> T?) -> T? {
            guard let password = self.password else { return nil }
            return completion(password)
        }

        private static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter
        }()

    }
}
