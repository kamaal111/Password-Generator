//
//  Shell.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 02/10/2021.
//

import Foundation

struct Shell {
    private init() { }

    enum Errors: Error {
        case resourceNotFound(name: String)
        case generalError(error: Error)
    }

    static func zsh(_ command: String) -> String {
        shell("/bin/zsh", command)
    }

    static func urlDecoder(_ urlPath: String) -> String {
        urlPath
            .replacingOccurrences(of: " ", with: "\\ \\")
            .replacingOccurrences(of: ")", with: "\\)")
    }

    private static func shell(_ launchPath: String, _ command: String) -> String {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = launchPath
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!

        return output
    }
}
