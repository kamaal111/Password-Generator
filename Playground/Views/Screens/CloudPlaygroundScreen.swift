//
//  CloudPlaygroundScreen.swift
//  Password-Generator
//
//  Created by Kamaal Farah on 20/10/2021.
//

#if DEBUG
import SwiftUI
import ConsoleSwift
import CloudKit
import ShrimpExtensions

struct CloudPlaygroundScreen: View {
    @EnvironmentObject
    private var coreDataModel: CoreDataModel

    var body: some View {
        FeaturePlaygroundScreenWrapper(title: "Cloud Playground") {
            PlaygroundFormButton(text: "Save a password", action: saveAPassword)
                .padding(.bottom, .xs)
            PlaygroundFormButton(text: "Get all records", action: getAllPasswords)
                .padding(.bottom, .xs)
        }
        .onAppear(perform: {
            coreDataModel.fetchAllPasswords()
        })
    }

    private func getAllPasswords() {
        CloudKitController.shared.fetchAll(ofType: CorePassword.recordType) { result in
            let records: [CKRecord]
            switch result {
            case .failure(let failure):
                console.error(Date(), failure.localizedDescription, failure)
                return
            case .success(let success): records = success
            }
            records.enumerated().forEach { enumaratedRecord in
                console.log(Date(), enumaratedRecord.offset, enumaratedRecord.element)
            }
        }
    }

    private func saveAPassword() {
        guard let firstPassword = coreDataModel.savedPasswords.first else { return }

        CloudKitController.shared.fetchByID(firstPassword.id, ofType: CorePassword.recordType) { result in
            let records: [CKRecord]
            switch result {
            case .failure(let failure):
                console.error(Date(), failure.localizedDescription, failure)
                return
            case .success(let success): records = success
            }

            var recordToSave = firstPassword.ckRecord
            if let foundRecord = records.first(where: {
                $0[CorePassword.RecordKeys.id.rawValue] == firstPassword.id.nsString
            }) {
                recordToSave = firstPassword.ckRecord(from: foundRecord)
            }
            CloudKitController.shared.save(recordToSave) { result in
                let record: CKRecord?
                switch result {
                case .failure(let failure):
                    console.error(Date(), failure.localizedDescription, failure)
                    return
                case .success(let success): record = success
                }
                guard let recordID = record?[CorePassword.RecordKeys.id.rawValue] else { return }
                console.log(Date(), "saved record", recordID)
            }
        }
    }
}

struct CloudPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        CloudPlaygroundScreen()
            .environmentObject(CoreDataModel(preview: true))
    }
}
#endif
