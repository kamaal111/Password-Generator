//
//  PGLocale.swift
//  
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import Foundation

public struct PGLocale {
    private init() { }
}

extension PGLocale.Keys {
    /// Returns a localized string
    public var localized: String {
        localized()
    }

    /// Returns a localized string with the variables provided
    /// - Parameter variables: These variables are injected in to the localized string
    /// - Returns: A localized string
    public func localized(with variables: [CVarArg]? = nil) -> String {
        let bundle = Bundle.module
        guard let variables = variables else {
            return NSLocalizedString(self.rawValue, bundle: bundle, comment: "")
        }
        switch variables.count {
        case 0:
            return NSLocalizedString(self.rawValue, bundle: bundle, comment: "")
        case 1:
            return String(format: NSLocalizedString(self.rawValue, bundle: bundle, comment: ""), variables[0])
        default:
            #if DEBUG
            fatalError("Amount of variables are not supported")
            #else
            return NSLocalizedString(self.rawValue, bundle: bundle, comment: "")
            #endif
        }
    }
}
