//
//  CloudKitController.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 21/10/2021.
//

import CloudKit
import ICloutKit
import ConsoleSwift
import ShrimpExtensions

final class CloudKitController {

    let recordTypes = [
        CorePassword.description()
    ]

    private var subscriptions: [CKSubscription] = []
    private let iCloutKit = ICloutKit(containerID: Constants.cloudContainerId, databaseType: .private)

    static let shared = CloudKitController()

    func save(_ record: CKRecord, completion: @escaping (Result<CKRecord?, Error>) -> Void) {
        let preparedRecord = record
        preparedRecord["updated_date"] = Date()
        iCloutKit.save(preparedRecord, completion: completion)
    }

    @available(macOS 12.0.0, iOS 15.0.0, *)
    @discardableResult
    func save(_ record: CKRecord) async throws -> CKRecord? {
        let preparedRecord = record
        preparedRecord["updated_date"] = Date()
        return try await iCloutKit.save(record)
    }

    func saveMultiple(_ records: [CKRecord], completion: @escaping (Result<[CKRecord], Error>) -> Void) {
        guard !records.isEmpty else {
            completion(.success(records))
            return
        }
        let preparedRecords: [CKRecord] = records.map { record in
            record["updated_date"] = Date()
            return record
        }
        iCloutKit.saveMultiple(preparedRecords, completion: completion)
    }

    func delete(_ record: CKRecord, completion: @escaping (Result<CKRecord.ID, Error>) -> Void) {
        iCloutKit.delete(record, completion: completion)
    }

    @available(macOS 12.0.0, iOS 15.0.0, *)
    func delete(_ record: CKRecord) async throws -> CKRecord.ID {
        try await iCloutKit.delete(record)
    }

    func fetchAll(ofType objectType: String, completion: @escaping (Result<[CKRecord], Error>) -> Void) {
        let predicate = NSPredicate(value: true)
        fetch(ofType: objectType, withPredicate: predicate, completion: completion)
    }

    @available(macOS 12.0.0, iOS 15.0.0, *)
    func fetchAll(ofType objectType: String) async throws -> [CKRecord] {
        let predicate = NSPredicate(value: true)
        return try await fetch(ofType: objectType, withPredicate: predicate)
    }

    func fetchByID(_ id: UUID, ofType objectType: String, completion: @escaping (Result<[CKRecord], Error>) -> Void) {
        let predicate = NSPredicate(format: "id == %@", id.nsString)
        fetch(ofType: objectType, withPredicate: predicate, completion: completion)
    }

    func fetchByIDs(
        _ ids: [UUID],
        ofType objectType: String,
        completion: @escaping (Result<[CKRecord], Error>) -> Void) {
            let predicate = NSPredicate(format: "id in %@", ids.map({ $0.nsString }))
            fetch(ofType: objectType, withPredicate: predicate, completion: completion)
    }

    func fetch(
        ofType objectType: String,
        withPredicate predicate: NSPredicate,
        completion: @escaping (Result<[CKRecord], Error>) -> Void) {
            iCloutKit.fetch(ofType: objectType, by: predicate, completion: completion)
    }

    @available(macOS 12.0.0, iOS 15.0.0, *)
    func fetch(ofType objectType: String, withPredicate predicate: NSPredicate) async throws -> [CKRecord] {
        try await iCloutKit.fetch(ofType: objectType, by: predicate)
    }

    func subscripeToAll() {
        #if !targetEnvironment(simulator)
        iCloutKit.fetchAllSubscriptions { [weak self] result in
            guard let self = self else { return }

            let subscriptions: [CKSubscription]
            switch result {
            case .failure(let failure):
                console.error(Date(), failure.localizedDescription, failure)
                return
            case .success(let success): subscriptions = success
            }

            console.log(Date(), "loaded subscription ->", subscriptions)

            var organizedSubscriptions: [String: CKSubscription] = [:]
            for subscription in subscriptions {
                if let recordType = (subscription as? CKQuerySubscription)?.recordType,
                   self.recordTypes.contains(recordType) {
                    organizedSubscriptions[recordType] = subscription
                }
            }

            console.log(Date(), "organized subscriptions ->", organizedSubscriptions)

            self.subscriptions = organizedSubscriptions.values.asArray()

            guard Features.createCloudSubscriptions else { return }

            let subcriptionsToCreate = self.recordTypes
                .filter({ recordType in
                    !organizedSubscriptions.keys.contains(recordType)
                })

            console.log(Date(), "subscriptions to create", subcriptionsToCreate)

            subcriptionsToCreate
                .forEach({ recordType in
                    console.log(Date(), "subscribing to", recordType)

                    let predicate = NSPredicate(value: true)
                    self.iCloutKit.subscribe(toType: recordType, by: predicate) { [weak self] result in
                        let subscription: CKSubscription
                        switch result {
                        case .failure(let failure):
                            console.error(Date(), failure.localizedDescription, failure)
                            return
                        case .success(let success): subscription = success
                        }
                        self?.subscriptions.append(subscription)
                    }
                })
        }
        #endif
    }

}
