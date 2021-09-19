//
//  UserDefaults+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import Foundation

extension UserDefaults {
    @UserDefault(key: .letterLength)
    static var letterLength: Int?
    @UserDefault(key: .lowercaseLettersEnabled)
    static var lowercaseLettersEnabled: Bool?
    @UserDefault(key: .capitalLettersEnabled)
    static var capitalLettersEnabled: Bool?
    @UserDefault(key: .numeralsEnabled)
    static var numeralsEnabled: Bool?
    @UserDefault(key: .symbolsEnabled)
    static var symbolsEnabled: Bool?
    @UserDefault(key: .shakeTimes)
    static var shakeTimes: Int?
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
        case letterLength
        case lowercaseLettersEnabled
        case capitalLettersEnabled
        case numeralsEnabled
        case symbolsEnabled
        case shakeTimes
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
