//
//  FeedbackSheet.swift
//  Password-Generator (iOS)
//
//  Created by Kamaal M Farah on 12/10/2021.
//

import SwiftUI
import MessageUI
import SalmonUI
import PGLocale

struct FeedbackSheet: View {
    @Binding var isShown: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?

    let email: String

    var body: some View {
        KMailView(isShowing: $isShown,
                  result: $result,
                  emailAddress: email,
                  emailSubject: PGLocale.Keys.FEEDBACK_APP.localized(with: [Constants.appName]))
    }
}
