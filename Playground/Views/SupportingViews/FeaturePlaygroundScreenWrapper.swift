//
//  FeaturePlaygroundScreenWrapper.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 20/10/2021.
//

import SwiftUI

struct FeaturePlaygroundScreenWrapper<Content: View>: View {
    @EnvironmentObject
    private var stackNavigator: StackNavigator

    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading) {
            content
        }
        .ktakeSizeEagerly(alignment: .topLeading)
        .padding(.horizontal, .large)
        .padding(.vertical, .medium)
        .navigationTitle(Text(title))
        .macBackButton(action: { stackNavigator.navigate(to: nil) })
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct FeaturePlaygroundScreenWrapper_Previews: PreviewProvider {
    static var previews: some View {
        FeaturePlaygroundScreenWrapper(title: "Playing") {
            Text("Yes")
        }
    }
}
