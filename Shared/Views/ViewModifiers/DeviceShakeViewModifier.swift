//
//  DeviceShakeViewModifier.swift
//  Password-Generator (iOS)
//
//  Created by Kamaal M Farah on 19/09/2021.
//

import SwiftUI

extension UIWindow {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            UserDefaults.shakeTimes.add(1)
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

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}
