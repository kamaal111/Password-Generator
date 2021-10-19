//
//  KeychainPlaygroundScreen.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 17/10/2021.
//

#if DEBUG
import SwiftUI
import SalmonUI
import Security

struct KeychainPlaygroundScreen: View {
    @EnvironmentObject
    private var stackNavigator: StackNavigator

    private let keychainHanger = KeychainHanger(prefix: Constants.bundleIdentifier)

    var body: some View {
        VStack(alignment: .leading) {
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
        .ktakeSizeEagerly(alignment: .topLeading)
        .padding(.horizontal, .large)
        .padding(.vertical, .medium)
        .navigationTitle(Text("Keychain playground"))
        .macBackButton(action: { stackNavigator.navigate(to: nil) })
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
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

struct KeychainHanger {
    let prefix: String

    func deleteItems(query: KHQuery, type: KHPasswordTypes) {
        var deleteItemsQuery: [CFString: Any] = [
            kSecClass: type.securityClass,
            kSecReturnData: true,
            kSecReturnAttributes: true
        ]
        if let username = query.username {
            deleteItemsQuery[kSecAttrAccount] = username
        }
        if let application = query.application {
            deleteItemsQuery[kSecAttrServer] = applicationWithPrefix(prefix: prefix, application: application)
        }

        SecItemDelete(deleteItemsQuery as CFDictionary)
    }

    func updateItems(
        query: KHQuery,
        account: String?,
        password: String?,
        application: String?,
        type: KHPasswordTypes) -> OSStatus {
            var getItemsQuery: [CFString: Any] = [
                kSecClass: type.securityClass,
                kSecReturnData: true,
                kSecReturnAttributes: true
            ]
            if let username = query.username {
                getItemsQuery[kSecAttrAccount] = username
            }
            if let application = query.application {
                getItemsQuery[kSecAttrServer] = applicationWithPrefix(prefix: prefix, application: application)
            }

            var updateFields: [CFString: Any] = [:]
            if let account = account {
                updateFields[kSecAttrAccount] = account
            }
            if let password = password {
                updateFields[kSecValueData] = password.data(using: .utf8)!
            }
            if let application = application {
                updateFields[kSecAttrServer] = applicationWithPrefix(prefix: prefix, application: application)
            }

            let status = SecItemUpdate(getItemsQuery as CFDictionary, updateFields as CFDictionary)
            return status
    }

    func getItems(
        query: KHQuery,
        amount: Int,
        type: KHPasswordTypes) -> KHResult<[KHItem]?> {
            var getItemsQuery: [CFString: Any] = [
                kSecClass: type.securityClass,
                kSecReturnAttributes: true,
                kSecReturnData: true,
                kSecMatchLimit: amount
            ]
            if let username = query.username {
                getItemsQuery[kSecAttrAccount] = username
            }
            if let application = query.application {
                getItemsQuery[kSecAttrServer] = applicationWithPrefix(prefix: prefix, application: application)
            }

            var getItemsReference: AnyObject?
            let getItemsStatus = SecItemCopyMatching(getItemsQuery as CFDictionary, &getItemsReference)

            let getItemsResults: [NSDictionary]
            if let unwrappedReference = getItemsReference as? NSDictionary {
                getItemsResults = [unwrappedReference]
            } else if let unwrappedReference = getItemsReference as? [NSDictionary] {
                getItemsResults = unwrappedReference
            } else {
                return KHResult(status: getItemsStatus, item: nil)
            }

            let hangerItems = getItemsResults.map { item in
                KHItem(original: item)
            }
            return KHResult(status: getItemsStatus, item: hangerItems)
    }

    func saveItem(
        password: String,
        username: String?,
        application: String?,
        type: KHPasswordTypes) -> KHResult<KHItem?> {
            var keychainItemQuery: [CFString: Any] = [
                kSecValueData: password.data(using: .utf8)!,
                kSecClass: type.securityClass,
                kSecReturnData: true,
                kSecReturnAttributes: true
            ]
            if let username = username {
                keychainItemQuery[kSecAttrAccount] = username
            }
            if let application = application {
                keychainItemQuery[kSecAttrServer] = applicationWithPrefix(prefix: prefix, application: application)
            }

            var setItemReference: AnyObject?
            let itemAddedStatus = SecItemAdd(keychainItemQuery as CFDictionary, &setItemReference)

            guard let setItemResult = setItemReference as? NSDictionary else {
                return KHResult(status: itemAddedStatus, item: nil)
            }

            return KHResult(status: itemAddedStatus, item: KHItem(original: setItemResult))
    }

    private func applicationWithPrefix(prefix: String, application: String) -> String? {
        "\(prefix).\(application)"
    }
}

struct KHQuery {
    let username: String?
    let application: String?

    init(username: String?, application: String?) {
        self.username = username
        self.application = application
    }
}

struct KHResult<T> {
    let status: OSStatus
    let item: T
}

enum KHPasswordTypes {
    case internet

    var securityClass: CFString {
        switch self {
        case .internet: return kSecClassInternetPassword
        }
    }
}

struct KHItem {
    let original: NSDictionary

    init(original: NSDictionary) {
        self.original = original
    }

    var password: String? {
        guard let passwordData = original[kSecValueData] as? Data else { return nil }
        return String(data: passwordData, encoding: .utf8)
    }

    var username: String? {
        original[kSecAttrAccount] as? String
    }
}

struct KeychainPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        KeychainPlaygroundScreen()
    }
}
#endif
