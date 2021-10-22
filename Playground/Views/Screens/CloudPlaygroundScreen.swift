//
//  CloudPlaygroundScreen.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 20/10/2021.
//

#if DEBUG
import SwiftUI
import ConsoleSwift

struct CloudPlaygroundScreen: View {
    @EnvironmentObject
    private var coreDataModel: CoreDataModel

    var body: some View {
        FeaturePlaygroundScreenWrapper(title: "Cloud Playground") {
            PlaygroundFormButton(text: "Save a password", action: saveAPassword)
                .padding(.bottom, .xs)
            PlaygroundFormButton(text: "Get all records", action: getAllPasswords)
                .padding(.bottom, .xs)
        }
        .onAppear(perform: {
            coreDataModel.fetchAllPasswords()
        })
    }

    private func getAllPasswords() {
        CloudKitController.shared.fetchAll(ofType: CorePassword.recordType) { result in
            print(result)
        }
    }

    private func saveAPassword() {
        guard let firstPassword = coreDataModel.savedPasswords.first else { return }
        console.log(Date(), "record", firstPassword.ckRecord)

        CloudKitController.shared.save(firstPassword.ckRecord) { result in
            print(result)
        }
    }
}

struct CloudPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        CloudPlaygroundScreen()
            .environmentObject(CoreDataModel(preview: true))
    }
}
#endif
