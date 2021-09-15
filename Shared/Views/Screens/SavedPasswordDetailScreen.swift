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
            Text(viewModel.passwordLabel)
        }
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
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

struct SavedPasswordDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        SavedPasswordDetailScreen()
            .environmentObject(StackNavigator(registeredScreens: [.savedPasswordDetails]))
            .environmentObject(CoreDataModel(preview: true))
    }
}
