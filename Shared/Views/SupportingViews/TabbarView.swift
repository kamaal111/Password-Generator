//
//  TabbarView.swift
//  Password-Generator (iOS)
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI

struct TabbarView: View {
    @EnvironmentObject
    private var namiNavigator: NamiNavigator

    var body: some View {
        TabView(selection: $namiNavigator.selectedTab) {
            ForEach(NamiNavigator.tabbarItems) { item in
                NavigationView {
                    MainView(selectedStack: item.navigationPoint)
                }
                .tabItem({
                    Image(systemName: item.systemImage)
                    Text(item.title)
                })
                .tag(item.navigationPoint?.rawValue ?? 0)
            }
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
            .environmentObject(NamiNavigator())
    }
}
