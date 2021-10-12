//
//  SettingsView+ViewModel.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 12/10/2021.
//

import SwiftUI
import PGLocale
#if canImport(MessageUI)
import MessageUI
#endif

extension SettingsView {
    final class ViewModel: ObservableObject {

        @Published var showSheet = false
        @Published private(set) var activeSheet: ActiveSheet? {
            didSet { activeSheetDidSet() }
        }
        #if canImport(MessageUI)
        @Published var feedbackResult: Result<MFMailComposeResult, Error>?
        #endif

        var versionText: String? {
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        }

        var sendFeedbackButtonIsEnabled: Bool {
            #if canImport(MessageUI)
            let canSendMail = MFMailComposeViewController.canSendMail()
            return canSendMail
            #elseif os(macOS)
            return true
            #endif
        }

        func onFeedbackPress() {
            #if os(iOS)
            activeSheet = .feedback
            #elseif os(macOS)
            guard let service = NSSharingService(named: NSSharingService.Name.composeEmail) else { return }
            service.subject = PGLocale.Keys.FEEDBACK_APP.localized(with: [Constants.appName])
            service.recipients = [Constants.email]
            service.perform(withItems: [])
            #endif
        }

        private func activeSheetDidSet() {
            guard activeSheet != nil else { return }
            showSheet = true
        }

    }
}

extension SettingsView.ViewModel {
    enum ActiveSheet {
        case feedback
    }
}
