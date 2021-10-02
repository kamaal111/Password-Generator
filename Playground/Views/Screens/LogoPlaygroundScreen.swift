//
//  LogoPlaygroundScreen.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 26/09/2021.
//

#if DEBUG
import SwiftUI
import SalmonUI

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
    @State private var exportLogoSize = "200"
    @State private var logoCurvedSize: CGFloat = 16

    var body: some View {
        VStack(alignment: .leading) {
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
        .ktakeSizeEagerly(alignment: .topLeading)
        .padding(.horizontal, .large)
        .padding(.vertical, .medium)
        .navigationTitle(Text("Logo Customizer"))
        .onChange(of: exportLogoSize, perform: { newValue in
            exportLogoSize = newValue.filter({ $0.isNumber })
        })
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

    private func exportLogoAsIconSet() {
        guard let pngData = logoToExport.snapshot().pngData,
        let temporaryFileURL = NSURL.fileURL(withPathComponents: [NSTemporaryDirectory()])
        else { return }
//        let temporaryFilename = "AppIcon.appiconset"
        let shellResult = Shell.runAppIconGenerator(input: pngData, output: temporaryFileURL)
        let shellOutput: String
        switch shellResult {
        case .failure(let failure):
            print(failure)
            return
        case .success(let success): shellOutput = success
        }
        print(shellOutput)
    }
}

struct LogoPlaygroundButton: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(.accentColor)
                .fontWeight(.semibold)
        }
        .buttonStyle(PlainButtonStyle())
    }
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

extension Shell {
    enum AppIconGeneratorErrors: Error {
        case resourceNotFound(name: String)
        case generalError(error: Error)
        case temporaryFileWentWrong
    }

    @discardableResult
    static func runAppIconGenerator(input: Data, output: URL) -> Result<String, AppIconGeneratorErrors> {
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryFilename = "\(UUID().uuidString).png"
        guard let temporaryFileURL = NSURL.fileURL(withPathComponents: [
            temporaryDirectory,
            temporaryFilename
        ]) else { return .failure(.temporaryFileWentWrong) }
        do {
            try input.write(to: temporaryFileURL)
        } catch {
            return .failure(.generalError(error: error))
        }

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
        let output = Shell.zsh("\(appIconGeneratorPath) -o \(output.relativePath) -i \(temporaryFileURL.relativePath)")
        return .success(output)
    }
}

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
