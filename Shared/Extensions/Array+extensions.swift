//
//  Array+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 03/10/2021.
//

import Foundation

extension Array {
    func findIndex<T: Equatable>(by keyPath: KeyPath<Element, T>, is comparisonValue: T) -> Int? {
        self.firstIndex(where: { $0[keyPath: keyPath] == comparisonValue })
    }
}
