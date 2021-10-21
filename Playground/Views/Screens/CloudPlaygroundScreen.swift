//
//  CloudPlaygroundScreen.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 20/10/2021.
//

#if DEBUG
import SwiftUI

struct CloudPlaygroundScreen: View {
    var body: some View {
        FeaturePlaygroundScreenWrapper(title: "Cloud Playground") {
            Text("Yes")
        }
    }
}

struct CloudPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        CloudPlaygroundScreen()
    }
}
#endif
