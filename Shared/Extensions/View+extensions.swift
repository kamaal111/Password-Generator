//
//  View+extensions.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import SwiftUI

extension View {
    func padding(_ edges: Edge.Set = .all, _ length: AppSizes) -> some View {
        self.padding(edges, length.rawValue)
    }

    func takeSizeEagerly(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
}
