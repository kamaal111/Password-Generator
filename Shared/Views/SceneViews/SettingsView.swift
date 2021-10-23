//
//  SettingsView.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 12/10/2021.
//

import SwiftUI
import SalmonUI

struct SettingsView: View {
    @EnvironmentObject
    private var userData: UserData

    @StateObject
    private var viewModel = ViewModel()

    var body: some View {
        VStack {
            #if os(macOS)
            FormHeader(title: .SETTINGS)
                .padding(.bottom, .xs)
            #endif
            // - TODO: Localize this
            SettingsFormToggle(state: $userData.iCloudSyncingEnabled, label: "iCloud syncing")
                #if os(macOS)
                .padding(.horizontal, .xs)
                #endif
            SettingsFormButton(
                title: .SEND_FEEDBACK,
                imageSystemName: "paperplane",
                action: viewModel.onFeedbackPress)
                .disabled(!viewModel.sendFeedbackButtonIsEnabled)
            if let versionText = viewModel.versionText {
                SettingsFormRow(label: .VERSION, value: versionText)
                    #if os(macOS)
                    .padding(.horizontal, .xs)
                    #endif
            }
        }
        .padding(.horizontal, .large)
        .padding(.vertical, .medium)
        .ktakeSizeEagerly(alignment: .topLeading)
        #if os(iOS)
        .navigationTitle(Text(localized: .SETTINGS))
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $viewModel.showSheet) {
            settingsSheet()
        }
        #endif
    }

    #if os(iOS)
    private func settingsSheet() -> some View {
        switch viewModel.activeSheet {
        case .feedback:
            return FeedbackSheet(isShown: $viewModel.showSheet,
                                 result: $viewModel.feedbackResult,
                                 email: Constants.email)
        default:
            return FeedbackSheet(isShown: $viewModel.showSheet,
                                 result: $viewModel.feedbackResult,
                                 email: Constants.email)
        }
    }
    #endif
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
