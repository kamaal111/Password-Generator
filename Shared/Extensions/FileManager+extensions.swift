//
//  FileManager+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 02/10/2021.
//

import Foundation

extension FileManager {
    func findDirectoryOrFile(inDirectory directory: URL, searchPath: String) throws -> URL? {
        let content = try self.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: nil,
            options: [])
        return content.find(by: \.lastPathComponent, is: searchPath)
    }
}
