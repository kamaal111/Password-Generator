//
//  Image+extensions.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 26/09/2021.
//

import SwiftUI
import ConsoleSwift

#if canImport(AppKit)
extension NSImage {
    private var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation,
                let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }

    func download(filename: String) {
        guard let pngData = pngData else { return }
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.nameFieldStringValue = filename
        savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        savePanel.begin { (result: NSApplication.ModalResponse) in
            if result == .OK {
                guard let saveURL = savePanel.url else { return }
                do {
                    try pngData.write(to: saveURL)
                } catch {
                    console.error(Date(), error.localizedDescription, error)
                    return
                }
                console.log(Date(), "file saved")
                return
            }
            console.error(Date(), "could not save file", result)
        }
    }
}
#elseif canImport(UIKit)
extension UIImage {
    func download(filename: String) {
        UIImageWriteToSavedPhotosAlbum(self, nil, nil, nil)
        console.log(Date(), "saved image to photo album")
    }
}
#endif
