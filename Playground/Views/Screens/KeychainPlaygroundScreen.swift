//
//  KeychainPlaygroundScreen.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 17/10/2021.
//

#if DEBUG
import SwiftUI
import SalmonUI
import KeychainHanger

struct KeychainPlaygroundScreen: View {
    @EnvironmentObject
    private var stackNavigator: StackNavigator

    private let keychainHanger = KeychainHanger(prefix: Constants.bundleIdentifier)

    var body: some View {
        FeaturePlaygroundScreenWrapper(title: "Keychain playground") {
            Button(action: saveItem) {
                Text("Create password")
                    .foregroundColor(.accentColor)
                    .font(.headline)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, .xs)

            Button(action: getItems) {
                Text("Get password")
                    .foregroundColor(.accentColor)
                    .font(.headline)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, .xs)

            Button(action: updateItem) {
                Text("Update password")
                    .foregroundColor(.accentColor)
                    .font(.headline)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, .xs)

            Button(action: deleteItems) {
                Text("Delete password")
                    .foregroundColor(.accentColor)
                    .font(.headline)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, .xs)
        }
    }

    private func updateItem() {
        let status = keychainHanger
            .updateItems(
                query: .init(username: "kamaalio", application: "kamaal.io"),
                account: nil,
                password: "kamaru22",
                application: nil,
                type: .internet)
        print("Operation finished with status: \(status)")
    }

    private func saveItem() {
        let savedPassword = keychainHanger
            .saveItem(
                password: "kamaru21",
                username: "kamaalio",
                application: "kamaal.io",
                type: .internet)

        print(savedPassword.status)
        print(savedPassword.item?.password ?? "")
        print(savedPassword.item?.original ?? [:])
    }

    private func getItems() {
        let result = keychainHanger
            .getItems(query: .init(username: nil, application: "kamaal.io"), amount: 5, type: .internet)

        print(result.status)
        result.item?.forEach({ item in
            print(item.password ?? "")
            print(item.username ?? "")
            print(item.original)
        })
    }

    private func deleteItems() {
        keychainHanger.deleteItems(query: .init(username: "kamaalio", application: "kamaal.io"), type: .internet)
        print("item deleted")
    }
}

struct KeychainPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        KeychainPlaygroundScreen()
    }
}
#endif
