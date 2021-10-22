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
            Button(action: {
                CloudKitController.shared.getAccountStatus { result in
                    print(result)
                }
                guard let firstPassword = coreDataModel.savedPasswords.first else { return }
                console.log(Date(), "record", firstPassword.ckRecord)

                CloudKitController.shared.save(firstPassword.ckRecord) { result in
                    print(result)
                }
            }) {
                Text("Save a password")
                    .foregroundColor(.accentColor)
                    .font(.headline)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, .xs)
        }
        .onAppear(perform: {
            coreDataModel.fetchAllPasswords()
        })
    }
}

struct CloudPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        CloudPlaygroundScreen()
            .environmentObject(CoreDataModel(preview: true))
    }
}
#endif
