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

    @State private var logoFirstBackgroundColor = Self.selectableColors[0]
    @State private var logoSecondBackgroundColor = Self.selectableColors[1]
    @State private var logoFirstSheildColor = Self.selectableColors[1]
    @State private var logoSecondSheildColor = Self.selectableColors[2]
    @State private var logoTextColor = Self.selectableColors[3]
    @State private var logoHasCurvedCorners = true
    @State private var shadesOfLogoFirstBackgroundColor = 3
    @State private var logoIsTransparent = false
    @State private var exportLogoSize = "200"

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(showsIndicators: false) {
                FormHeader(title: "App logo")
                    .padding(.bottom, .xs)
                HStack(alignment: .top) {
                    logoView(size: .squared(150))
                    VStack(alignment: .leading) {
                        Button(action: exportLogo) {
                            Text("Export Logo")
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(PlainButtonStyle())
                        KFloatingTextField(text: $exportLogoSize, title: "Export logo size", textFieldType: .numbers)
                    }
                    .padding(.horizontal, .medium)
                    .padding(.top, .small)
                }
                .ktakeWidthEagerly(alignment: .leading)
                VStack(alignment: .leading) {
                    Text("Is transparent")
                    Divider()
                    Toggle(logoIsTransparent ? "Yup" : "Nope", isOn: $logoIsTransparent)
                }
                .padding(.bottom, .medium)
                VStack(alignment: .leading) {
                    Text("Curved corners")
                    Divider()
                    Toggle(logoHasCurvedCorners ? "Yup" : "Nope", isOn: $logoHasCurvedCorners)
                }
                .padding(.bottom, .medium)
                LogoPlaygroundColorSelector(
                    selectedColor: $logoFirstBackgroundColor,
                    title: "First background color",
                    selectableColors: Self.selectableColors)
                    .padding(.bottom, .medium)
                VStack(alignment: .leading) {
                    Text("Shades of first background color")
                    Divider()
                    Stepper("\(shadesOfLogoFirstBackgroundColor)", value: $shadesOfLogoFirstBackgroundColor)
                }
                .padding(.bottom, .medium)
                LogoPlaygroundColorSelector(
                    selectedColor: $logoSecondBackgroundColor,
                    title: "Second background color",
                    selectableColors: Self.selectableColors)
                    .padding(.bottom, .medium)
                LogoPlaygroundColorSelector(
                    selectedColor: $logoFirstSheildColor,
                    title: "First sheild color",
                    selectableColors: Self.selectableColors)
                    .padding(.bottom, .medium)
                LogoPlaygroundColorSelector(
                    selectedColor: $logoSecondSheildColor,
                    title: "Second sheild color",
                    selectableColors: Self.selectableColors)
                    .padding(.bottom, .medium)
                LogoPlaygroundColorSelector(
                    selectedColor: $logoTextColor,
                    title: "Text color",
                    selectableColors: Self.selectableColors)
                    .padding(.bottom, .medium)
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
            curvedCorners: logoHasCurvedCorners,
            isTransparent: logoIsTransparent)
    }

    private func exportLogo() {
        let size = CGFloat(Double(exportLogoSize)!)
        let logoImage = logoView(size: .squared(size))
        logoImage.snapshot().download(filename: "logo.png")
    }

    private static let selectableColors: [Color] = [
        .black,
        .AccentColor,
        .SecondaryAccentColor,
        .white
    ]
}

struct LogoPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        LogoPlaygroundScreen()
    }
}
#endif
