//
//  SettingsView+ViewModel.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 12/10/2021.
//

import SwiftUI
import PGLocale

extension SettingsView {
    final class ViewModel: ObservableObject {

        var versionText: String? {
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        }

        var sendFeedbackButtonIsEnabled: Bool {
            #if canImport(MessageUI)
            return false
//            let canSendMail = MFMailComposeViewController.canSendMail()
//            return canSendMail
            #elseif os(macOS)
            return true
            #endif
        }

        func onFeedbackPress() {
            #if os(iOS)
//            activeSheet = .feedback
            #elseif os(macOS)
            guard let service = NSSharingService(named: NSSharingService.Name.composeEmail) else { return }
            service.subject = PGLocale.Keys.FEEDBACK_APP.localized(with: [Constants.appName])
            service.recipients = [Constants.email]
            service.perform(withItems: [])
            #endif
        }

    }
}
