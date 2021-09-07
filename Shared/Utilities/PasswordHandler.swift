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
    private var symbols: String = ""

    init(enableLowers: Bool, enableUppers: Bool, enableNumerals: Bool, enableSymbols: Bool) {
        if enableNumerals {
            self.numbers = (0..<10).map({ "\($0)" }).joined()
        }
        if enableLowers {
            self.lowers = Self.alphabet
        }
        if enableUppers {
            self.uppers = Self.alphabet.uppercased()
        }
        if enableSymbols {
            self.symbols = "+=-_)(*&^%$#@!±§~`<>,./?;:\"'\\|{}[]"
        }
    }

    private var combinedCharacters: String {
        numbers + lowers + uppers + symbols
    }

    func create(length: Int) -> String {
        (0..<length)
            .compactMap({ _ in
                combinedCharacters.randomElement()?.string
            })
            .joined()
    }

    private static let alphabet: String = {
        "abcdefghijklmnopqrstuvwxyz"
    }()
}
