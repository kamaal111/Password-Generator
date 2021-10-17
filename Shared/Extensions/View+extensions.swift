//
//  View+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI
import ConsoleSwift

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

    func macBackButton(action: @escaping () -> Void) -> some View {
        self
            #if os(macOS)
            .toolbar(content: {
                ToolbarItem(placement: .navigation) {
                    Button(action: action) {
                        Image(systemName: "chevron.left")
                    }
                }
            })
            #endif
    }

    #if os(iOS)
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view!

        let targetSize = controller.view.intrinsicContentSize
        let targetPoint = CGPoint(x: 0, y: 0)
        let targetBounds = CGRect(origin: targetPoint, size: targetSize)
        view.bounds = targetBounds
        view.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    #else
    func snapshot() -> NSImage {
        let controller = NSHostingController(rootView: self)
        let view = controller.view

        let targetSize = view.intrinsicContentSize
        let targetPoint = CGPoint(x: -(targetSize.width / 2), y: -(targetSize.height / 2))
        let targetBounds = CGRect(origin: targetPoint, size: targetSize)
        guard let bitmapRep = view.bitmapImageRepForCachingDisplay(in: targetBounds) else {
            console.error(Date(), "could not get bitmap representation")
            return NSImage()
        }
        bitmapRep.size = targetSize
        view.cacheDisplay(in: targetBounds, to: bitmapRep)

        let image = NSImage(size: targetSize)
        image.addRepresentation(bitmapRep)

        return image
    }
    #endif

    func padding(_ edges: Edge.Set = .all, _ length: AppSizes) -> some View {
        self.padding(edges, length.rawValue)
    }

    func cornerRadius(_ radius: AppSizes) -> some View {
        self.cornerRadius(radius.rawValue)
    }
}
