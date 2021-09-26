//
//  SavedPasswordsScreen.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 09/09/2021.
//

import SwiftUI

struct SavedPasswordsScreen: View {
    @EnvironmentObject
    private var coreDataModel: CoreDataModel

    @StateObject
    private var viewModel = ViewModel()
    @StateObject
    private var stackNavigator = StackNavigator(registeredScreens: Self.registeredScreens)

    var body: some View {
        #if os(macOS)
        view
            .environmentObject(stackNavigator)
        #else
        view
        #endif
    }

    private var view: some View {
        VerticalForm {
            Section(header: sectionHeader) {
                #if os(macOS)
                ScrollView {
                    savedPasswordSectionContent
                }
                #else
                savedPasswordSectionContent
                #endif
            }
        }
        .navigationTitle(Text(localized: .SAVED_PASSWORDS))
        .onAppear(perform: coreDataModel.fetchAllPasswords)
        .onShake(perform: {
            #if DEBUG
            stackNavigator.navigate(to: .playground)
            #endif
        })
        .withNavigationPoints(selectedScreen: $stackNavigator.selectedScreen, stackNavigator: stackNavigator)
    }

    private var savedPasswordSectionContent: some View {
        ForEach(coreDataModel.savedPasswords, id: \.self) { password in
            SavedPasswordListItem(
                password: password,
                hasBeenLastCopied: viewModel.hasBeenLastCopied(password),
                onPress: {
                    let options = [
                        "password_id": password.id.uuidString
                    ]
                    stackNavigator.navigate(to: .savedPasswordDetails, options: options)
                })
                .contextMenu {
                    Button(action: { viewModel.copyPassword(from: password) }) {
                        Text(localized: .COPY_PASSWORD)
                    }
                    if password.name != nil {
                        Button(action: { viewModel.copyName(from: password) }) {
                            Text(localized: .COPY_NAME)
                        }
                    }
                }
        }
    }

    private var sectionHeader: some View {
        Text(localized: .PASSWORDS)
            .foregroundColor(.secondary)
            .takeWidthEagerly(alignment: .leading)
    }

    #if DEBUG
    private static let registeredScreens: [StackNavigator.Screens] = [.savedPasswordDetails, .playground]
    #else
    private static let registeredScreens: [StackNavigator.Screens] = [.savedPasswordDetails]
    #endif
}

struct SavedPasswordsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SavedPasswordsScreen()
            .environmentObject(CoreDataModel(preview: true))
    }
}
