//
//  Data+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 02/10/2021.
//

import SwiftUI
import ConsoleSwift

extension Data {
    var hexString: String {
        let hexString = self
            .map({ String(format: "%02.2hhx", $0) })
            .joined()
        return hexString
    }

    #if canImport(AppKit)
    func download(filename: String) {
        // - FIXME: REFACTOR THIS TO BE USED IN IMAGES AS WELL
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = true
        savePanel.nameFieldStringValue = filename
        savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        savePanel.begin { (result: NSApplication.ModalResponse) in
            if result == .OK {
                guard let saveURL = savePanel.url else { return }
                do {
                    try self.write(to: saveURL)
                } catch {
                    console.error(Date(), error.localizedDescription, error)
                    return
                }
                console.log(Date(), "file saved")
                return
            }
            console.log(Date(), "could not save file", result)
        }
    }
    #endif
}
