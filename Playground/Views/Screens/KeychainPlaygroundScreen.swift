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

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: savePassword) {
                Text("Create password")
                    .foregroundColor(.accentColor)
                    .font(.headline)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, .xs)

            Button(action: getPassword) {
                Text("Get password")
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

    private func savePassword() {
        let savedPassword = KeychainHanger
            .savePassword(password: "kamaru21", username: "kamaalio2", website: "kamaal.io", type: .internet)

        print(savedPassword.status)
        print(savedPassword.item?.password ?? "")
        print(savedPassword.item?.original ?? [:])
    }

    private func getPassword() {
        let result = KeychainHanger.getPasswords(website: "kamaal.io", account: nil, amount: 5, type: .internet)

        print(result.status)
        result.item?.forEach({ item in
            print(item.password ?? "")
            print(item.username ?? "")
            print(item.original)
        })
    }
}

struct KeychainHanger {
    private init() { }

    static func getPasswords(
        website: String?,
        account: String?,
        amount: Int,
        type: KHPasswordTypes) -> KHResult<[KHItem]?> {
            var getItemsQuery: [CFString: Any] = [
                kSecClass: kSecClassInternetPassword,
                kSecReturnAttributes: true,
                kSecReturnData: true,
                kSecMatchLimit: amount
            ]
            if let account = account {
                getItemsQuery[kSecAttrAccount] = account
            }
            if let website = website {
                getItemsQuery[kSecAttrServer] = website
            }

            var getItemsReference: AnyObject?
            let getItemsStatus = SecItemCopyMatching(getItemsQuery  as CFDictionary, &getItemsReference)

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

    static func savePassword(
        password: String,
        username: String,
        website: String,
        type: KHPasswordTypes) -> KHResult<KHItem?> {
            let keychainItemQuery = [
                kSecValueData: password.data(using: .utf8)!,
                kSecAttrAccount: username,
                kSecAttrServer: website,
                kSecClass: type.securityClass,
                kSecReturnData: true,
                kSecReturnAttributes: true
            ] as CFDictionary

            var setItemReference: AnyObject?
            let itemAddedStatus = SecItemAdd(keychainItemQuery, &setItemReference)

            guard let setItemResult = setItemReference as? NSDictionary else {
                return KHResult(status: itemAddedStatus, item: nil)
            }

            return KHResult(status: itemAddedStatus, item: KHItem(original: setItemResult))
    }
}

struct KHResult<T> {
    let status: OSStatus
    let item: T
}

enum KHPasswordTypes {
    case internet
    case generic

    var securityClass: CFString {
        switch self {
        case .internet: return kSecClassInternetPassword
        case .generic: return kSecClassGenericPassword
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
