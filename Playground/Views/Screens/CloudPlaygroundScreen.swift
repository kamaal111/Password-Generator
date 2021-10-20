//
//  CloudPlaygroundScreen.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 20/10/2021.
//

#if DEBUG
import SwiftUI

import CloudKit
import ICloutKit

struct CloudPlaygroundScreen: View {
    var body: some View {
        FeaturePlaygroundScreenWrapper(title: "Cloud Playground") {
            Text("Yes")
        }
    }
}

final class CloudKitController {

    private var subscriptions: [CKSubscription] = []

}

struct CloudPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        CloudPlaygroundScreen()
    }
}
#endif
