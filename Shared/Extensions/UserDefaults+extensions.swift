//
//  UserDefaults+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import Foundation

extension UserDefaults {
    @UserDefault(key: .lengthPicker)
    static var lengthPicker: Int?
    @UserDefault(key: .lowercaseLetters)
    static var lowercaseLetters: Bool?
    @UserDefault(key: .capitalLetters)
    static var capitalLetters: Bool?
    @UserDefault(key: .numerals)
    static var numerals: Bool?
}

@propertyWrapper
struct UserDefault<Value> {
    let key: Keys
    let container: UserDefaults

    init(key: Keys, container: UserDefaults = .standard) {
        self.key = key
        self.container = container
    }

    enum Keys: String {
        case lengthPicker
        case lowercaseLetters
        case capitalLetters
        case numerals
    }

    var wrappedValue: Value? {
        get {
            let valueToReturn = container.object(forKey: constructKey(key.rawValue)) as? Value
            return valueToReturn
        }
        set {
            container.set(newValue, forKey: constructKey(key.rawValue))
        }
    }

    var projectedValue: UserDefault {
        self
    }

    func removeValue() {
        container.removeObject(forKey: constructKey(key.rawValue))
    }

    private func constructKey(_ key: String) -> String {
        "\(Constants.bundleIdentifier).UserDefaults.\(key)"
    }
}
