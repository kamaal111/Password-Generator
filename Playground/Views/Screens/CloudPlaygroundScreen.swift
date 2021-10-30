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
    private var savedPasswordsManager: SavedPasswordsManager

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
                            Text(recordKey.replacingOccurrences(of: "_", with: " ").capitalized)
                                .bold()
                                .lineLimit(1)
                                .frame(minWidth: screenSize.width / 5, maxWidth: screenSize.width / 5)
                        }
                    }
                    .padding(.bottom, .small)
                    ForEach(currentRecords[selectedType] ?? [], id: \.self) { record in
                        HStack {
                            ForEach(currentRecordKeys, id: \.self) { recordKey in
                                CloudPlaygroundItem(
                                    recordValue: record[recordKey],
                                    mask: recordKey == "value",
                                    width: screenSize.width / 5)
                            }
                        }
                    }
                    .ktakeWidthEagerly(alignment: .leading)
                }
                .padding(.vertical, .medium)
            } else {
                LoadingIndicator(loading: $loading)
                    .ktakeSizeEagerly()
            }
        }
        .kBindToFrameSize($screenSize)
        .onAppear(perform: {
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
}

struct CloudPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        CloudPlaygroundScreen()
            .environmentObject(SavedPasswordsManager(preview: true))
    }
}
#endif
