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
        @Published var editMode: EditMode = .inactive
        @Published var loading = false
        @Published private(set) var showToolbar = false

        func toggleShowToobar(to state: Bool) {
            showToolbar = state
        }

        func toggleEditMode() {
            withAnimation {
                editMode = editMode.toggled()
            }
        }

        func toggleLoading(to state: Bool) {
            DispatchQueue.main.async { [weak self] in
                withAnimation {
                    self?.loading = state
                }
            }
        }

        func hasBeenLastCopied(_ password: CommonPassword) -> Bool {
            password.id == lastCopiedPasswordID
        }

        func copyPassword(from password: CommonPassword) {
            Clipboard.copy(password.value)
            handlePasswordValueCopy(password)
        }

        func copyName(from password: CommonPassword) {
            guard let name = password.name else { return }
            Clipboard.copy(name)
            handlePasswordValueCopy(password)
        }

        private func handlePasswordValueCopy(_ password: CommonPassword) {
            withAnimation {
                lastCopiedPasswordID = password.id
            }
        }

    }
}
