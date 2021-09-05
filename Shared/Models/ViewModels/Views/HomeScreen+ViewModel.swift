//
//  HomeScreen+ViewModel.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import Foundation

extension HomeScreen {
    final class ViewModel: ObservableObject {

        @Published var lengthPicker: Int {
            didSet { UserDefaults.lengthPicker = lengthPicker }
        }
        @Published var lowercaseLetters: Bool {
            didSet { UserDefaults.lowercaseLetters = lowercaseLetters }
        }

        init() {
            self.lengthPicker = UserDefaults.lengthPicker ?? 16
            self.lowercaseLetters = UserDefaults.lowercaseLetters ?? false
        }

    }
}
