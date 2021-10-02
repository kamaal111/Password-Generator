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
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }

    func download(filename: String) {
        guard let pngData = self.pngData else { return }
        pngData.download(filename: filename)
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
