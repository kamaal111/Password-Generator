//
//  HomeScreen.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject
    private var viewModel = ViewModel()

    var body: some View {
        #if os(macOS)
        view
            .padding(.all, .medium)
            .takeSizeEagerly(alignment: .topLeading)
            .navigationTitle(Text(Constants.appName))
        #elseif os(iOS)
        view
            .navigationTitle(Text(Constants.appName))
        #endif
    }

    private var view: some View {
        VerticalForm {
            SpacedHStack(left: {
                Text(localized: .LENGTH_LABEL)
            }, right: {
                Stepper("\(viewModel.lengthPicker)", value: $viewModel.lengthPicker, in: Constants.passwordLengthRange)
            })
            SpacedHStack(left: {
                Text(localized: .LOWERCASE_LETTERS)
            }, right: {
                Toggle("", isOn: $viewModel.lowercaseLetters)
            })
            .padding(.trailing, DeviceModel.device == .mac ? -4 : 0)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
