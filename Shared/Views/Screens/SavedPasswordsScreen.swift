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

    var body: some View {
        VerticalForm {
            Section(header: Text(localized: .PASSWORDS)) {
                ForEach(coreDataModel.savedPasswords, id: \.self) { password in
                    Text(password.value)
                }
            }
        }
        .navigationTitle(Text(localized: .SAVED_PASSWORDS))
        .onAppear(perform: {
            coreDataModel.fetchAllPasswords()
        })
    }
}

struct SavedPasswordsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SavedPasswordsScreen()
            .environmentObject(CoreDataModel(preview: true))
    }
}
