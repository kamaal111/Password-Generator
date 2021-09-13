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

    var body: some View {
        VerticalForm {
            Section(header: sectionHeader) {
                #if os(macOS)
                ScrollView {
                    ForEach(coreDataModel.savedPasswords, id: \.self) { password in
                        SavedPasswordListItem(
                            password: password,
                            hasBeenLastCopied: viewModel.hasBeenLastCopied(password),
                            onPress: { viewModel.onPasswordPress(password) })
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
                #else
                ForEach(coreDataModel.savedPasswords, id: \.self) { password in
                    SavedPasswordListItem(password: password, onPress: { onPasswordPress(password) })
                }
                #endif
            }
        }
        .navigationTitle(Text(localized: .SAVED_PASSWORDS))
        .onAppear(perform: coreDataModel.fetchAllPasswords)
    }

    private var sectionHeader: some View {
        Text(localized: .PASSWORDS)
            .foregroundColor(.secondary)
            .takeWidthEagerly(alignment: .leading)
    }
}

struct SavedPasswordsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SavedPasswordsScreen()
            .environmentObject(CoreDataModel(preview: true))
    }
}
