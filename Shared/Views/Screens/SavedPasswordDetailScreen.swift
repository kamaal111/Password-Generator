//
//  SavedPasswordDetailScreen.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 13/09/2021.
//

import SwiftUI

struct SavedPasswordDetailScreen: View {
    @EnvironmentObject
    private var stackNavigator: StackNavigator
    @EnvironmentObject
    private var coreDataModel: CoreDataModel

    @StateObject
    private var viewModel = ViewModel()

    var body: some View {
        #if os(macOS)
        view
            .toolbar(content: {
                ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                    Button(action: { stackNavigator.navigate(to: nil) }) {
                        Image(systemName: "chevron.left")
                    }
                }
            })
        #else
        view
        #endif
    }

    private var view: some View {
        VStack {
            CopyableDetailsRow(
                showPassword: .constant(false),
                label: .NAME_LABEL,
                value: viewModel.passwordNameLabel,
                showCopyButton: viewModel.showCopyNameButton,
                showShowPasswordButton: false,
                onCopyPress: viewModel.copyName)
            CopyableDetailsRow(
                showPassword: $viewModel.showPassword,
                label: .PASSWORD_LABEL,
                value: viewModel.passwordLabel,
                showCopyButton: true,
                showShowPasswordButton: true,
                onCopyPress: viewModel.copyPassword)
            Spacer()
            VStack {
                DateDetailsRow(label: .CREATED_LABEL, dateString: viewModel.creationDateString)
                DateDetailsRow(label: .UPDATED_LABEL, dateString: viewModel.updatedDateString)
            }
            .takeWidthEagerly()
        }
        .padding(.all, .medium)
        .takeSizeEagerly(alignment: .topLeading)
        .navigationTitle(Text(viewModel.navigationTitleString))
        .onAppear(perform: {
            guard let passwordIDString = stackNavigator.currentOptions?["password_id"],
                  let passwordID = UUID(uuidString: passwordIDString),
                  let password = coreDataModel.getPasswordByID(is: passwordID) else {
                stackNavigator.navigate(to: nil)
                return
            }
            viewModel.setPassword(password)
        })
        /// - TODO: ADD SOME NAVIGATION BUTTONS TO EDIT, SAVE OR CANCEL
    }
}

struct SavedPasswordDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        SavedPasswordDetailScreen()
            .environmentObject(StackNavigator(registeredScreens: [.savedPasswordDetails]))
            .environmentObject(CoreDataModel(preview: true))
    }
}
