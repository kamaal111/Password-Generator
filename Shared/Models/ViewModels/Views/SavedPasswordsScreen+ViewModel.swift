//
//  SavedPasswordsScreen+ViewModel.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 13/09/2021.
//

import Foundation

extension SavedPasswordsScreen {
    final class ViewModel: ObservableObject {

        func onPasswordPress(_ password: CorePassword) {
            print(password)
        }

        func copyPassword(from password: CorePassword) {
            Clipboard.copy(password.value)
        }

        func copyName(from password: CorePassword) {
            guard let name = password.name else { return }
            Clipboard.copy(name)
        }

    }
}
