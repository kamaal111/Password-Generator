//
//  View+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI

extension View {
    func withNavigationPoints(
        selectedScreen: Binding<StackNavigator.Screens?>,
        stackNavigator: StackNavigator) -> some View {
        #if os(iOS)
        ZStack {
            ForEach(stackNavigator.registeredScreens, id: \.self) { screen in
                NavigationLink(
                    destination: screen.view.environmentObject(stackNavigator),
                    tag: screen,
                    selection: selectedScreen,
                    label: { EmptyView() })
            }
            self
        }
        #else
        ZStack {
            if let view = selectedScreen.wrappedValue?.view {
                view
                    .environmentObject(stackNavigator)
            } else {
                self
            }
        }
        #endif
    }

    func padding(_ edges: Edge.Set = .all, _ length: AppSizes) -> some View {
        self.padding(edges, length.rawValue)
    }

    func takeSizeEagerly(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }

    func takeWidthEagerly(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
}
