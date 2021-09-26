//
//  BindToFrameSize.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 26/09/2021.
//

import SwiftUI

extension View {
    func bindToFrameSize(_ size: Binding<CGSize>) -> some View {
        self.modifier(BindToFrameSize(size: size))
    }
}

private struct BindToFrameSize: ViewModifier {
    @Binding var size: CGSize

    func body(content: Content) -> some View {
        content.overlay(GeometryReader(content: overlay(for:)))
    }

    func overlay(for geometry: GeometryProxy) -> some View {
        let size = geometry.size
        if self.size.width != size.width || self.size.height != size.height {
            DispatchQueue.main.async {
                self.size = geometry.size
            }
        }
        return Text("")
    }
}
