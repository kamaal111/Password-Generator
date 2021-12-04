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

@available(macOS 12.0.0, iOS 15.0.0, *)
struct CloudPlaygroundScreen: View {
    @EnvironmentObject
    private var savedPasswordsManager: SavedPasswordsManager

    @State private var selectedType = CloudKitController.shared.recordTypes.first!
    @State private var currentRecords: [String: [CKRecord]] = [:]
    @State private var currentRecordKeys: [String] = []
    @State private var loading = false
    @State private var screenSize = CGSize(width: 400, height: 400)
    @State private var showItemActionSheet = false
    @State private var selectedItem: CKRecord?

    var body: some View {
        PlaygroundScreenWrapper(title: "Cloud Playground") {
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
                Button(action: {
                    Task {
                        await fetchAllRecords()
                    }
                }) {
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
                            Button(action: {
                                selectedItem = record
                                showItemActionSheet = true
                            }) {
                                ForEach(currentRecordKeys, id: \.self) { recordKey in
                                    CloudPlaygroundItem(
                                        recordValue: record[recordKey],
                                        mask: recordKey == "value",
                                        width: screenSize.width / 5,
                                        isHighlighted: recordKey == "id")
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
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
        .sheet(isPresented: $showItemActionSheet) {
            KSheetStack(title: "Actions",
                        leadingNavigationButton: { Text("") },
                        trailingNavigationButton: {
                Button(action: { showItemActionSheet = false }) {
                    Text(localized: .CLOSE)
                        .bold()
                }
            }) {
                VStack {
                    Button(action: {
                        Task {
                            await deleteRecord()
                        }
                    }) {
                        Text(localized: .DELETE)
                            .foregroundColor(.accentColor)
                            .bold()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.top, .medium)
            }
            #if os(macOS)
            .frame(minWidth: 300, minHeight: 144)
            #endif
        }
        .kBindToFrameSize($screenSize)
        .onAppear(perform: {
            Task {
                await fetchAllRecords()
            }
        })
    }

    private func deleteRecord() async {
        guard let selectedItem = selectedItem else { return }

        showItemActionSheet = false
        loading = true

        do {
            _ = try await CloudKitController.shared.delete(selectedItem)
        } catch {
            console.error(Date(), error.localizedDescription, error)
            DispatchQueue.main.async {
                loading = false
            }
            return
        }

        await fetchAllRecords()
    }

    private func fetchAllRecords() async {
        loading = true

        let records: [CKRecord]
        do {
            records = try await CloudKitController.shared.fetchAll(ofType: selectedType)
        } catch {
            console.error(Date(), error.localizedDescription, error)
            DispatchQueue.main.async {
                loading = false
            }
            return
        }

        DispatchQueue.main.async {
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

@available(macOS 12.0.0, *)
struct CloudPlaygroundScreen_Previews: PreviewProvider {
    static var previews: some View {
        CloudPlaygroundScreen()
            .environmentObject(SavedPasswordsManager(preview: true))
    }
}
#endif
