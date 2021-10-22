//
//  CloudKitController.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 21/10/2021.
//

import CloudKit
import ICloutKit
import ConsoleSwift

final class CloudKitController {

    private var subscriptions: [CKSubscription] = []
    private let iCloutKit = ICloutKit(containerID: Constants.cloudContainerId, databaseType: .private)
    private let subscriptionsWanted = [
        CorePassword.description()
    ]

    static let shared = CloudKitController()

    func save(_ record: CKRecord, completion: @escaping (Result<CKRecord?, Error>) -> Void) {
        let preparedRecord = record
        preparedRecord["updated_date"] = Date()
        iCloutKit.save(preparedRecord, completion: completion)
    }

    #if !os(macOS)
    @available(macOS 12.0.0, iOS 15.0.0, *)
    func save(_ record: CKRecord) async -> Result<CKRecord?, Error> {
        let preparedRecord = record
        preparedRecord["updated_date"] = Date()
        return await withCheckedContinuation { continuation in
            iCloutKit.save(preparedRecord, completion: { result in
                continuation.resume(returning: result)
            })
        }
    }
    #endif

    func getAccountStatus(completion: @escaping (Result<Bool, Error>) -> Void) {
        iCloutKit.getAccountStatus(completion: completion)
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
                   self.subscriptionsWanted.contains(recordType) {
                    organizedSubscriptions[recordType] = subscription
                }
            }

            console.log(Date(), "organized subscriptions ->", organizedSubscriptions)

            self.subscriptions = organizedSubscriptions.values.asArray()

            guard Features.createCloudSubscriptions else { return }

            let subcriptionsToCreate = self.subscriptionsWanted
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
