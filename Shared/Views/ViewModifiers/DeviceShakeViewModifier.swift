//
//  DeviceShakeViewModifier.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 19/09/2021.
//

import SwiftUI

#if os(iOS)
extension UIWindow {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            UserDefaults.shakeTimes += 1
            NotificationCenter.default.post(name: .deviceDidShake, object: nil)
        }
     }
}

private struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: .deviceDidShake), perform: { _ in
                action()
            })
    }
}
#endif

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        #if os(iOS)
        self.modifier(DeviceShakeViewModifier(action: action))
        #else
        self
        #endif
    }
}
