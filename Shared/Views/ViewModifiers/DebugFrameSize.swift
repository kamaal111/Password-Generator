//
//  DebugFrameSize.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 26/09/2021.
//

import SwiftUI

extension View {
    func debugFrameSize(borderColor: Color) -> some View {
        self.modifier(DebugFrameSize(borderColor: borderColor))
    }
}

private struct DebugFrameSize: ViewModifier {
    let borderColor: Color

    func body(content: Content) -> some View {
        content
            .overlay(GeometryReader(content: { (geometry: GeometryProxy) in
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                    Rectangle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundColor(borderColor)
                    Text("\(Int(geometry.size.width))x\(Int(geometry.size.height))")
                        .font(.caption2)
                        .foregroundColor(borderColor)
                        .padding(2)
                }
            }))
    }
}
