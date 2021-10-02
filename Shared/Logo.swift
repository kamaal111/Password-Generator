//
//  Logo.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 26/09/2021.
//

import SwiftUI
import SalmonUI

struct Logo: View {
    let backgroundColors: [Color]
    let firstShieldColor: Color
    let secondShieldColor: Color
    let textColor: Color
    let shadesOfFirstBackgroundColor: Int
    let size: CGSize
    let curveSize: CGFloat
    let curvedCorners: Bool
    let isTransparent: Bool

    var body: some View {
        ZStack {
            if !isTransparent {
                backgroundColor
            }
            // - TODO: ADD BANNER FOR DEV APP
            ZStack {
                Image(systemName: "shield.fill")
                    .size(.squared(size.width / 1.7))
                    .foregroundColor(firstShieldColor)
                Image(systemName: "shield.lefthalf.fill")
                    .size(.squared(size.width / 1.65))
                    .foregroundColor(secondShieldColor)
                VStack {
                    Text("PG")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(textColor)
                    Image(systemName: "lock.fill")
                        .size(.squared(size.width / 8))
                        .foregroundColor(textColor)
                        .padding(.top, -8)
                }
            }
        }
        .frame(width: size.width, height: size.height)
        .cornerRadius(curvedCorners ? curveSize : 0)
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
            backgroundColors: [.black, .AccentColor],
            firstShieldColor: .AccentColor,
            secondShieldColor: .SecondaryAccentColor,
            textColor: .white,
            shadesOfFirstBackgroundColor: 2,
            size: .squared(150),
            curveSize: AppSizes.medium.rawValue,
            curvedCorners: true,
            isTransparent: false)
            .padding(.all, .medium)
            .previewLayout(.sizeThatFits)
    }
}
