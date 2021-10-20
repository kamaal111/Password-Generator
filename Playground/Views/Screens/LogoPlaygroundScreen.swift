//
//  LogoPlaygroundScreen.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 26/09/2021.
//

#if DEBUG
import SwiftUI
import SalmonUI
import ConsoleSwift

struct LogoPlaygroundScreen: View {
    @EnvironmentObject
    private var stackNavigator: StackNavigator

    @State private var logoFirstBackgroundColor = selectableColors[0]
    @State private var logoSecondBackgroundColor = selectableColors[1]
    @State private var logoFirstSheildColor = selectableColors[1]
    @State private var logoSecondSheildColor = selectableColors[2]
    @State private var logoTextColor = selectableColors[3]
    @State private var logoHasCurvedCorners = true
    @State private var shadesOfLogoFirstBackgroundColor = 3
    @State private var logoIsTransparent = false
    @State private var exportLogoSize = "400"
    @State private var logoCurvedSize: CGFloat = 16

    var body: some View {
        FeaturePlaygroundScreenWrapper(title: "Logo Customizer") {
            ScrollView(showsIndicators: false) {
                FormHeader(title: "App logo")
                    .padding(.bottom, .xs)
                HStack(alignment: .top) {
                    logoView(size: .squared(150))
                    VStack(alignment: .leading) {
                        LogoPlaygroundButton(text: "Export Logo", action: exportLogo)
                        #if canImport(AppKit)
                        LogoPlaygroundButton(text: "Export Logo as IconSet", action: exportLogoAsIconSet)
                            .padding(.top, .xs)
                            .padding(.bottom, .xxs)
                        #endif
                        KFloatingTextField(text: $exportLogoSize, title: "Export logo size", textFieldType: .numbers)
                    }
                    .padding(.horizontal, .medium)
                    .padding(.top, .small)
                }
                .ktakeWidthEagerly(alignment: .leading)
                LogoPlaygroundConfigurator(
                    logoFirstBackgroundColor: $logoFirstBackgroundColor,
                    logoSecondBackgroundColor: $logoSecondBackgroundColor,
                    logoFirstSheildColor: $logoFirstSheildColor,
                    logoSecondSheildColor: $logoSecondSheildColor,
                    logoTextColor: $logoTextColor,
                    shadesOfLogoFirstBackgroundColor: $shadesOfLogoFirstBackgroundColor,
                    logoIsTransparent: $logoIsTransparent,
                    logoHasCurvedCorners: $logoHasCurvedCorners,
                    logoCurvedSize: $logoCurvedSize)
            }
        }
        .onChange(of: exportLogoSize, perform: { newValue in
            exportLogoSize = newValue.filter({ $0.isNumber })
        })
    }

    private func logoView(size: CGSize) -> some View {
        Logo(
            backgroundColors: [logoFirstBackgroundColor, logoSecondBackgroundColor],
            firstShieldColor: logoFirstSheildColor,
            secondShieldColor: logoSecondSheildColor,
            textColor: logoTextColor,
            shadesOfFirstBackgroundColor: shadesOfLogoFirstBackgroundColor,
            size: size,
            curveSize: logoCurvedSize,
            curvedCorners: logoHasCurvedCorners,
            isTransparent: logoIsTransparent)
    }

    private var logoToExport: some View {
        let size = CGFloat(Double(exportLogoSize)!)
        return logoView(size: .squared(size))
    }

    private func exportLogo() {
        logoToExport.snapshot().download(filename: "logo.png")
    }

    #if canImport(AppKit)
    private func exportLogoAsIconSet() {
        guard let pngData = logoToExport.snapshot().pngData,
        let temporaryDirectoryURL = NSURL.fileURL(withPathComponents: [NSTemporaryDirectory()])
        else { return }

        let shellResult = Shell.runAppIconGenerator(input: pngData, output: temporaryDirectoryURL)
        let shellOutput: String
        switch shellResult {
        case .failure(let failure):
            console.error(Date(), failure.localizedDescription, failure)
            return
        case .success(let success): shellOutput = success
        }
        console.log(Date(), shellOutput)

        let fileManager = FileManager.default
        let iconSetURL: URL?
        do {
            iconSetURL = try fileManager.findDirectoryOrFile(
                inDirectory: temporaryDirectoryURL,
                searchPath: "AppIcon.appiconset")
        } catch {
            console.error(Date(), error.localizedDescription, error)
            return
        }
        guard let iconSetURL = iconSetURL else { return }

        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = true
        savePanel.nameFieldStringValue = "AppIcon.appiconset"
        savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        savePanel.begin { (result: NSApplication.ModalResponse) in
            var maybeError: Error?
            do {
                try onIconSaveBegin(response: result, saveURL: savePanel.url, iconSetURL: iconSetURL)
            } catch {
                maybeError = error
            }
            if let maybeError = maybeError {
                do {
                    try fileManager.removeItem(at: iconSetURL)
                } catch {
                    console.error(Date(), error.localizedDescription, error)
                    return
                }
                console.error(Date(), maybeError.localizedDescription, maybeError)
            }
        }
    }

    func onIconSaveBegin(response: NSApplication.ModalResponse, saveURL: URL?, iconSetURL: URL) throws {
        let fileManager = FileManager.default
        if response == .OK {
            guard let saveURL = saveURL else { return }
            if fileManager.fileExists(atPath: saveURL.path) {
                try fileManager.removeItem(at: saveURL)
            }
            try fileManager.moveItem(at: iconSetURL, to: saveURL)
            console.log(Date(), "file saved")
            return
        }
        console.log(Date(), "could not save file", response)
    }
    #endif
}

struct LogoPlaygroundConfigurator: View {
    @Binding var logoFirstBackgroundColor: Color
    @Binding var logoSecondBackgroundColor: Color
    @Binding var logoFirstSheildColor: Color
    @Binding var logoSecondSheildColor: Color
    @Binding var logoTextColor: Color
    @Binding var shadesOfLogoFirstBackgroundColor: Int
    @Binding var logoIsTransparent: Bool
    @Binding var logoHasCurvedCorners: Bool
    @Binding var logoCurvedSize: CGFloat

    var body: some View {
        LogoPlaygroundToggle(value: $logoIsTransparent, text: "Is transparent")
            .padding(.bottom, .medium)
        LogoPlaygroundToggle(value: $logoHasCurvedCorners, text: "Curved corners")
            .padding(.bottom, .medium)
        LogoPlaygroundStepper(
            value: $logoCurvedSize,
            text: "Curved size",
            stepperTitle: "\(logoCurvedSize)")
            .padding(.bottom, .medium)
        LogoPlaygroundColorSelector(
            selectedColor: $logoFirstBackgroundColor,
            title: "First background color",
            selectableColors: selectableColors)
            .padding(.bottom, .medium)
        LogoPlaygroundStepper(
            value: $shadesOfLogoFirstBackgroundColor,
            text: "Shades of first background color",
            stepperTitle: "\(shadesOfLogoFirstBackgroundColor)")
            .padding(.bottom, .medium)
        LogoPlaygroundColorSelector(
            selectedColor: $logoSecondBackgroundColor,
            title: "Second background color",
            selectableColors: selectableColors)
            .padding(.bottom, .medium)
        LogoPlaygroundColorSelector(
            selectedColor: $logoFirstSheildColor,
            title: "First sheild color",
            selectableColors: selectableColors)
            .padding(.bottom, .medium)
        LogoPlaygroundColorSelector(
            selectedColor: $logoSecondSheildColor,
            title: "Second sheild color",
            selectableColors: selectableColors)
            .padding(.bottom, .medium)
        LogoPlaygroundColorSelector(
            selectedColor: $logoTextColor,
            title: "Text color",
            selectableColors: selectableColors)
            .padding(.bottom, .medium)
    }
}

#if canImport(AppKit)
extension Shell {
    enum AppIconGeneratorErrors: Error {
        case resourceNotFound(name: String)
        case generalError(error: Error)
        case temporaryFileWentWrong
    }

    @discardableResult
    static func runAppIconGenerator(input: Data, output: URL) -> Result<String, AppIconGeneratorErrors> {
        guard let temporaryFileURL = NSURL.fileURL(withPathComponents: [
            NSTemporaryDirectory(),
            "\(UUID().uuidString).png"
        ]) else { return .failure(.temporaryFileWentWrong) }
        do {
            try input.write(to: temporaryFileURL)
        } catch {
            return .failure(.generalError(error: error))
        }

        let bundleResourceURL = Bundle.main.resourceURL!
        let appIconGeneratorName = "app-icon-generator"
        let appIconGenerator: URL?
        do {
            appIconGenerator = try FileManager.default.findDirectoryOrFile(
                inDirectory: bundleResourceURL,
                searchPath: appIconGeneratorName)
        } catch {
            switch cleanUp(temporaryFileURL: temporaryFileURL) {
            case .failure(let failure): return .failure(failure)
            case .success: break
            }
            return .failure(.generalError(error: error))
        }

        guard let appIconGenerator = appIconGenerator else {
            switch cleanUp(temporaryFileURL: temporaryFileURL) {
            case .failure(let failure): return .failure(failure)
            case .success: break
            }
            return .failure(.resourceNotFound(name: appIconGeneratorName))
        }

        let appIconGeneratorPath = urlDecoder(appIconGenerator.relativePath)
        let command = "\(appIconGeneratorPath) -o \(output.relativePath) -i \(temporaryFileURL.relativePath) -v"
        let output = Shell.zsh(command)

        switch cleanUp(temporaryFileURL: temporaryFileURL) {
        case .failure(let failure): return .failure(failure)
        case .success: break
        }
        return .success(output)
    }

    private static func cleanUp(temporaryFileURL: URL) -> Result<Void, AppIconGeneratorErrors> {
        do {
            try FileManager.default.removeItem(at: temporaryFileURL)
        } catch {
            return .failure(.generalError(error: error))
        }
        return .success(Void())
    }
}
#endif

private let selectableColors: [Color] = [
    .black,
    .AccentColor,
    .SecondaryAccentColor,
    .white
]

struct LogoPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        LogoPlaygroundScreen()
    }
}
#endif
