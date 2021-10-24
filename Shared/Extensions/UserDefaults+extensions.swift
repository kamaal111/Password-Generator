//
//  UserDefaults+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import Foundation

extension UserDefaults {
    @UserDefault(key: .letterLength, defaultValue: 16)
    static var letterLength: Int

    @UserDefault(key: .lowercaseLettersEnabled, defaultValue: true)
    static var lowercaseLettersEnabled: Bool

    @UserDefault(key: .capitalLettersEnabled, defaultValue: true)
    static var capitalLettersEnabled: Bool

    @UserDefault(key: .numeralsEnabled, defaultValue: true)
    static var numeralsEnabled: Bool

    @UserDefault(key: .symbolsEnabled, defaultValue: true)
    static var symbolsEnabled: Bool

    @UserDefault(key: .shakeTimes, defaultValue: 0)
    static var shakeTimes: Int

    @UserDefault(key: .enableICloudSyncing, defaultValue: true)
    static var enableICloudSyncing: Bool

    @OptionalUserDefault(key: .lastChosenSyncMethod)
    static var lastChosenSyncMethod: Data?
}

enum UserDefaultKeys: String {
    case letterLength
    case lowercaseLettersEnabled
    case capitalLettersEnabled
    case numeralsEnabled
    case symbolsEnabled
    case shakeTimes
    case enableICloudSyncing
    case lastChosenSyncMethod
}

@propertyWrapper
struct UserDefault<Value> {
    let key: UserDefaultKeys
    let defaultValue: Value
    let container: UserDefaults

    init(key: UserDefaultKeys, defaultValue: Value, container: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }

    var wrappedValue: Value {
        get {
            let valueToReturn = container.object(forKey: constructKey(key.rawValue)) as? Value
            return valueToReturn ?? defaultValue
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

@propertyWrapper
struct OptionalUserDefault<Value> {
    let key: UserDefaultKeys
    let container: UserDefaults

    init(key: UserDefaultKeys, container: UserDefaults = .standard) {
        self.key = key
        self.container = container
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

    var projectedValue: OptionalUserDefault {
        self
    }

    func removeValue() {
        container.removeObject(forKey: constructKey(key.rawValue))
    }

    private func constructKey(_ key: String) -> String {
        "\(Constants.bundleIdentifier).UserDefaults.\(key)"
    }
}
