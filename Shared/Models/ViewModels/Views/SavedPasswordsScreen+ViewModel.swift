//
//  SavedPasswordsScreen+ViewModel.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 13/09/2021.
//

import SwiftUI

extension SavedPasswordsScreen {
    final class ViewModel: ObservableObject {

        @Published private var lastCopiedPasswordID: UUID?

        func hasBeenLastCopied(_ password: CorePassword) -> Bool {
            password.id == lastCopiedPasswordID
        }

        func onPasswordPress(_ password: CorePassword) {
            print(password)
        }

        func copyPassword(from password: CorePassword) {
            Clipboard.copy(password.value)
            handlePasswordValueCopy(password)
        }

        func copyName(from password: CorePassword) {
            guard let name = password.name else { return }
            Clipboard.copy(name)
            handlePasswordValueCopy(password)
        }

        private func handlePasswordValueCopy(_ password: CorePassword) {
            withAnimation { [weak self] in
                self?.lastCopiedPasswordID = password.id
            }
        }

    }
}
