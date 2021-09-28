//
//  Logo.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 26/09/2021.
//

import SwiftUI

struct Logo: View {
    let backgroundColors: [Color]
    let shadesOfFirstBackgroundColor: Int
    let size: CGSize
    let curvedCorners: Bool

    var body: some View {
        ZStack {
            backgroundColor
        }
        .frame(width: size.width, height: size.height)
        .cornerRadius(curvedCorners ? .medium : .nada)
    }

    private var backgroundColor: LinearGradient {
        let backgroundColorsToUse: [Color]
        if self.backgroundColors.count > 1 {
            let colorsAfterFirst = self.backgroundColors.suffix(1)
            let firstBackgroundColor = self.backgroundColors.first
            let shadesOfFirstBackgroundColor: Int
            if self.shadesOfFirstBackgroundColor < 1 {
                shadesOfFirstBackgroundColor = 1
            } else {
                shadesOfFirstBackgroundColor = self.shadesOfFirstBackgroundColor
            }
            let multipliedFirstBackgroundColor = (0..<shadesOfFirstBackgroundColor)
                .compactMap({ _ in firstBackgroundColor })
            backgroundColorsToUse = multipliedFirstBackgroundColor + colorsAfterFirst
        } else {
            backgroundColorsToUse = self.backgroundColors
        }
        return LinearGradient(gradient: Gradient(colors: backgroundColorsToUse), startPoint: .bottom, endPoint: .top)
    }
}

struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        Logo(
            backgroundColors: [.black, .red],
            shadesOfFirstBackgroundColor: 1,
            size: .squared(150),
            curvedCorners: true)
    }
}
