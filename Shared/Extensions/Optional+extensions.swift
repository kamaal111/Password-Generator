//
//  Optional+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 19/09/2021.
//

import Foundation

extension Optional where Wrapped == Int {
    mutating func add(_ increment: Int) {
        self = self.added(increment)
    }

    func added(_ increment: Int) -> Int {
        (self ?? 0) + increment
    }
}
