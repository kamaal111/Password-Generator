//
//  SplashScreen.swift
//  Password-Generator (iOS)
//
//  Created by Kamaal M Farah on 03/10/2021.
//

import SwiftUI

private struct SplashScreen: View {
    var body: some View {
        Image("SplashLogo")
            .size(.squared(400))
            .padding(.bottom, 12)
    }
}

extension View {
    func withSplashScreen(isActive: Bool) -> some View {
        ZStack {
            if isActive {
                SplashScreen()
            } else {
                self
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
