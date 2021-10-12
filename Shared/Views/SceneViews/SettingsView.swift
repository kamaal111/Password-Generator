//
//  SettingsView.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 12/10/2021.
//

import SwiftUI
import SalmonUI

struct SettingsView: View {
    @StateObject
    private var viewModel = ViewModel()

    var body: some View {
        VStack {
            #if os(macOS)
            FormHeader(title: .SETTINGS)
                .padding(.bottom, .xs)
            #endif
            SettingsFormButton(
                title: .SEND_FEEDBACK,
                imageSystemName: "paperplane",
                action: viewModel.onFeedbackPress)
                .disabled(!viewModel.sendFeedbackButtonIsEnabled)
            if let versionText = viewModel.versionText {
                SettingsFormRow(label: .VERSION, value: versionText)
                    .padding(.horizontal, .xs)
            }
        }
        .padding(.horizontal, .large)
        .padding(.vertical, .medium)
        .ktakeSizeEagerly(alignment: .topLeading)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
