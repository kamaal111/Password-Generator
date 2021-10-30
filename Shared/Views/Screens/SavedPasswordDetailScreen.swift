//
//  SavedPasswordDetailScreen.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 13/09/2021.
//

import SwiftUI
import SalmonUI
import PGLocale

struct SavedPasswordDetailScreen: View {
    @EnvironmentObject
    private var stackNavigator: StackNavigator
    @EnvironmentObject
    private var savedPasswordsManager: SavedPasswordsManager

    @StateObject
    private var viewModel = ViewModel()

    var body: some View {
        VStack {
            CopyableDetailsRow(
                showValue: .constant(true),
                editValue: $viewModel.edittedName,
                label: .NAME_LABEL,
                value: viewModel.passwordNameLabel,
                showCopyButton: viewModel.showCopyNameButton,
                showShowValueButton: false,
                editMode: viewModel.editMode,
                onCopyPress: viewModel.copyName)
            CopyableDetailsRow(
                showValue: $viewModel.showPassword,
                editValue: $viewModel.edittedPasswordValue,
                label: .PASSWORD_LABEL,
                value: viewModel.passwordLabel,
                showCopyButton: true,
                showShowValueButton: true,
                editMode: viewModel.editMode,
                onCopyPress: viewModel.copyPassword)
            SettingsFormToggle(
                state: $viewModel.syncingIsEnabled,
                label: "\(PGLocale.Keys.SYNC_WITH_ICLOUD.localized):")
                .font(.headline)
                .disabled(!viewModel.editMode.isEditing)
                .padding(.trailing, .xxs)
            Spacer()
            VStack {
                DateDetailsRow(label: .CREATED_LABEL, dateString: viewModel.creationDateString)
                DateDetailsRow(label: .UPDATED_LABEL, dateString: viewModel.updatedDateString)
            }
            .ktakeWidthEagerly()
        }
        .padding(.all, .medium)
        .ktakeSizeEagerly(alignment: .topLeading)
        .navigationTitle(Text(viewModel.navigationTitleString))
        .onAppear(perform: handleOnAppear)
        #if os(macOS)
        .toolbar(content: {
            ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                Button(action: { stackNavigator.navigate(to: nil) }) {
                    Image(systemName: "chevron.left")
                }
            }
        })
        .toolbar(content: {
            trailingNavigationBarItem
        })
        #else
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: trailingNavigationBarItem)
        #endif
    }

    private var trailingNavigationBarItem: some View {
        HStack {
            if viewModel.editMode.isEditing {
                Button(action: viewModel.cancelEditing) {
                    Text(localized: .CANCEL)
                }
            }
            Button(action: {
                viewModel.toggleEditMode(onSave: { args in
                    guard let passwordID = viewModel.passwordID else { return }
                    savedPasswordsManager.editPassword(id: passwordID, args: args)
                })
            }) {
                Text(editMode: viewModel.editMode)
            }
        }
    }

    private func handleOnAppear() {
        guard let passwordIDString = stackNavigator.currentOptions?["password_id"],
              let passwordID = UUID(uuidString: passwordIDString),
              let password = savedPasswordsManager.getPasswordByID(is: passwordID) else {
            stackNavigator.navigate(to: nil)
            return
        }
        viewModel.setPassword(password)
    }
}

struct SavedPasswordDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        SavedPasswordDetailScreen()
            .environmentObject(StackNavigator(registeredScreens: [.savedPasswordDetails]))
            .environmentObject(SavedPasswordsManager(preview: true))
    }
}
