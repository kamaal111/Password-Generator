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
            Button(action: {
                let createdPasswordResult = KeychainHanger
                    .createPassword(password: "kamaru21", username: "kamaalio", website: "kamaal.io", type: .internet)

                let hangerItem: HangerItem
                switch createdPasswordResult {
                case .failure(let failure):
                    switch failure {
                    case .failure(let code): print("failed with code \(code)")
                    }
                    return
                case .success(let success):
                    guard let success = success else {
                        return
                    }
                    hangerItem = success
                }

                print(hangerItem.password)
                print(hangerItem.original)
            }) {
                Text("Create dictionary")
                    .foregroundColor(.accentColor)
                    .font(.headline)
            }
            .buttonStyle(PlainButtonStyle())
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
}

struct KeychainHanger {
    private init() { }

    static func createPassword(
        password: String,
        username: String,
        website: String,
        type: KHPasswordTypes) -> Result<HangerItem?, KHCreatePasswordErrors> {
            let securityClass: CFString
            switch type {
            case .internet: securityClass = kSecClassInternetPassword
            case .generic: securityClass = kSecClassGenericPassword
            }
            let keychainItemQuery = [
                kSecValueData: password.data(using: .utf8)!,
                kSecAttrAccount: username,
                kSecAttrServer: website,
                kSecClass: securityClass,
                kSecReturnData: true,
                kSecReturnAttributes: true
            ] as CFDictionary

            var setItemReference: AnyObject?
            let itemAddedStatus = SecItemAdd(keychainItemQuery, &setItemReference)
            if itemAddedStatus != 0 {
                return .failure(.failure(code: itemAddedStatus))
            }

            guard let setItemResult = setItemReference as? NSDictionary else { return .success(nil) }

            return .success(HangerItem(original: setItemResult))
    }
}

enum KHCreatePasswordErrors: Error {
    case failure(code: OSStatus)
}

enum KHPasswordTypes {
    case internet
    case generic
}

struct HangerItem {
    let original: NSDictionary

    init(original: NSDictionary) {
        self.original = original
    }

    var password: String? {
        guard let passwordData = original[kSecValueData] as? Data else { return nil }
        return String(data: passwordData, encoding: .utf8)
    }
}

struct KeychainPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        KeychainPlaygroundScreen()
    }
}
#endif
