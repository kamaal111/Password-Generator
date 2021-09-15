//
//  SavedPasswordDetailScreen+ViewModel.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 15/09/2021.
//

import Foundation

extension SavedPasswordDetailScreen {
    final class ViewModel: ObservableObject {

        @Published private var password: CorePassword?

        var navigationTitleString: String {
            password?.name ?? Self.dateFormatter.string(from: password?.creationDate ?? Date())
        }

        var passwordLabel: String {
            password?.maskedValue ?? ""
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
