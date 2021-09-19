//
//  Sequence+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 14/09/2021.
//

import Foundation

extension Sequence {
    func find<T: Equatable>(by keyPath: KeyPath<Element, T>, is comparisonValue: T) -> Element? {
        self.first(where: { $0[keyPath: keyPath] == comparisonValue })
    }
}
