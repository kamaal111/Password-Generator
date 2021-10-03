//
//  SavedPasswordsScreen.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 09/09/2021.
//

import SwiftUI
import SalmonUI

struct SavedPasswordsScreen: View {
    @EnvironmentObject
    private var coreDataModel: CoreDataModel

    @StateObject
    private var viewModel = ViewModel()
    @StateObject
    private var stackNavigator = StackNavigator(registeredScreens: Self.registeredScreens)

    var body: some View {
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
        #if os(macOS)
        .toolbar(content: {
            trailingNavigationBarItem
        })
        #else
        .navigationBarItems(trailing: trailingNavigationBarItem)
        .environment(\.editMode, $viewModel.editMode)
        #endif
    }

    private var trailingNavigationBarItem: some View {
        Button(action: viewModel.toggleEditMode) {
            Text(editMode: viewModel.editMode)
                .fontWeight(.semibold)
        }
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
                .contextMenu(menuItems: {
                    Button(action: { viewModel.copyPassword(from: password) }) {
                        Text(localized: .COPY_PASSWORD)
                    }
                    if password.name != nil {
                        Button(action: { viewModel.copyName(from: password) }) {
                            Text(localized: .COPY_NAME)
                        }
                    }
                })
        }
        .onDelete(perform: { indices in
            indices.forEach { index in
                print("index", index)
            }
        })
    }

    private var sectionHeader: some View {
        Text(localized: .PASSWORDS)
            .foregroundColor(.secondary)
            .ktakeWidthEagerly(alignment: .leading)
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
