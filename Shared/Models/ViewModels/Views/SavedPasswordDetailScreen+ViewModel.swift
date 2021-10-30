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

        @Published private var password: CommonPassword?
        @Published var showPassword = false
        @Published private(set) var editMode = EditMode.inactive
        @Published var edittedName = ""
        @Published var edittedPasswordValue = ""
        @Published var syncingIsEnabled = false

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

        var editPasswordArgs: CommonPassword.Args {
            var passwordName: String?
            if !edittedName.replacingOccurrences(of: " ", with: "").isEmpty {
                passwordName = edittedName
            }
            return .init(
                name: passwordName,
                value: edittedPasswordValue,
                source: syncingIsEnabled ? .iCloud : .coreData)
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

        func toggleEditMode(onSave: (CommonPassword.Args) -> Void) {
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

        func setPassword(_ password: CommonPassword) {
            self.password = password
            self.edittedName = password.name ?? ""
            self.edittedPasswordValue = password.value
            switch password.source {
            case .iCloud: syncingIsEnabled = true
            case .coreData: syncingIsEnabled = false
            }
        }

        private func passwordDateString(of keyPath: KeyPath<CommonPassword, Date>) -> String {
            withUnwrappedPassword { password in
                Self.dateFormatter.string(from: password[keyPath: keyPath])
            } ?? ""
        }

        private func withUnwrappedPassword<T>(completion: (CommonPassword) -> T?) -> T? {
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
