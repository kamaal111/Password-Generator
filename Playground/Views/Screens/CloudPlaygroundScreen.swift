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
import SalmonUI

struct CloudPlaygroundScreen: View {
    @EnvironmentObject
    private var coreDataModel: CoreDataModel

    @State private var selectedType = CloudKitController.shared.recordTypes.first!
    @State private var currentRecords: [String: [CKRecord]] = [:]
    @State private var currentRecordKeys: [String] = []
    @State private var loading = false
    @State private var screenSize = CGSize(width: 400, height: 400)

    var body: some View {
        FeaturePlaygroundScreenWrapper(title: "Cloud Playground") {
            HStack {
                Picker(selection: $selectedType, label: Text("")) {
                    ForEach(CloudKitController.shared.recordTypes, id: \.self) { recordType in
                        Text(recordType)
                            .tag(recordType)
                    }
                }
                .labelsHidden()
                .frame(maxWidth: 200)
                Spacer()
                Button(action: fetchAllRecords) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                }
            }
            if !loading {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(currentRecordKeys, id: \.self) { recordKey in
                            Text(recordKey)
                                .bold()
                                .lineLimit(1)
                                .frame(minWidth: screenSize.width / 5, maxWidth: screenSize.width / 5)
                        }
                    }
                    ForEach(currentRecords[selectedType] ?? [], id: \.self) { record in
                        HStack {
                            ForEach(currentRecordKeys, id: \.self) { recordKey in
                                CloudPlaygroundItem(recordValue: record[recordKey], width: screenSize.width / 5)
                            }
                        }
                    }
                    .ktakeWidthEagerly(alignment: .leading)
                }
                .padding(.vertical, .medium)
            } else {
                #if os(macOS)
                KActivityIndicator(isAnimating: $loading, style: .spinning)
                #else
                KActivityIndicator(isAnimating: $loading, style: .large)
                #endif
            }
            PlaygroundFormButton(text: "Save a password", action: saveAPassword)
                .padding(.bottom, .xs)
        }
        .kBindToFrameSize($screenSize)
        .onAppear(perform: {
            coreDataModel.fetchAllPasswords()
            fetchAllRecords()
        })
    }

    private func fetchAllRecords() {
        loading = true

        CloudKitController.shared.fetchAll(ofType: selectedType) { result in
            DispatchQueue.main.async {
                let records: [CKRecord]
                switch result {
                case .failure(let failure):
                    console.error(Date(), failure.localizedDescription, failure)
                    loading = false
                    return
                case .success(let success): records = success
                }

                var recordKeys: [String] = records.reduce([]) { result, record in
                    result + record.allKeys().filter({ !result.contains($0) })
                }

                if let idKeyIndex = recordKeys.firstIndex(of: "id") {
                    recordKeys.remove(at: idKeyIndex)
                    recordKeys = recordKeys.prepended("id")
                }

                currentRecordKeys = recordKeys
                currentRecords[selectedType] = records
                loading = false
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
