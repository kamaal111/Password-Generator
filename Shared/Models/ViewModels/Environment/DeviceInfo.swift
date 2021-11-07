//
//  DeviceInfo.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

final class DeviceInfo: ObservableObject {

    enum Device {
        case iPad
        case iPhone
        case mac
    }

    static let device: Device = {
        #if os(macOS)
        return .mac
        #elseif os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .iPad
        }
        return .iPhone
        #endif
    }()

    static let isPreview: Bool = {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }()

}
