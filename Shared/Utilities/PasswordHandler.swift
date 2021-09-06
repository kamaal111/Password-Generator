//
//  PasswordHandler.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 06/09/2021.
//

import Foundation
import ShrimpExtensions

struct PasswordHandler {
    private var numbers: String = ""
    private var lowers: String = ""
    private var uppers: String = ""

    init(enableLowers: Bool, enableUppers: Bool, enableNumerals: Bool) {
        if enableNumerals {
            self.numbers = (0..<10).map({ "\($0)" }).joined()
        }
        if enableLowers {
            self.lowers = Self.alphabet
        }
        if enableUppers {
            self.uppers = Self.alphabet.uppercased()
        }
    }

    var combinedCharacters: String {
        numbers + lowers + uppers
    }

    func create(length: Int) -> String {
        let password = (0..<length)
            .compactMap({ _ in
                combinedCharacters.randomElement()?.string
            })
            .joined()
        return password
    }

    private static let alphabet: String = {
        "abcdefghijklmnopqrstuvwxyz"
    }()
}
