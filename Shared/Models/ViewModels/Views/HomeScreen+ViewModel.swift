//
//  HomeScreen+ViewModel.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import Foundation

extension HomeScreen {
    final class ViewModel: ObservableObject {

        @Published var lengthPicker = 16
        @Published var isLowercased = false

    }
}
