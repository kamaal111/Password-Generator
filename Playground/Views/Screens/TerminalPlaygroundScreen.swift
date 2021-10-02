//
//  TerminalPlaygroundScreen.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 02/10/2021.
//

#if DEBUG
import SwiftUI

struct TerminalPlaygroundScreen: View {
    @EnvironmentObject
    private var stackNavigator: StackNavigator

    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .onAppear(perform: {
            Shell.runAppIconGenerator()
        })
        .navigationTitle(Text("Terminal runner"))
        #if os(macOS)
        .toolbar(content: {
            ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                Button(action: { stackNavigator.navigate(to: nil) }) {
                    Image(systemName: "chevron.left")
                }
            }
        })
        #else
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

extension Shell {
    @discardableResult
    static func runAppIconGenerator() -> Result<Void, Errors> {
        let bundleResourceURL = Bundle.main.resourceURL!
        let resources: [URL]
        do {
            resources = try FileManager.default.contentsOfDirectory(
                at: bundleResourceURL,
                includingPropertiesForKeys: nil,
                options: [])
        } catch {
            return .failure(.generalError(error: error))
        }
        let appIconGeneratorName = "app-icon-generator"
        guard let appIconGenerator = resources.find(by: \.lastPathComponent, is: appIconGeneratorName)
        else { return .failure(.resourceNotFound(name: appIconGeneratorName)) }
        let appIconGeneratorPath = urlDecoder(appIconGenerator.relativePath)
        let output = Shell.zsh(appIconGeneratorPath)
        print(output)
        return .success(Void())
    }
}

struct TerminalPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        TerminalPlaygroundScreen()
    }
}
#endif
