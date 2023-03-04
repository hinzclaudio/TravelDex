//
//  CKStore.swift
//  TravelDex
//
//  Created by Claudio Hinz on 06.03.23.
//

import Foundation
import CoreData
import CloudKit
import RxSwift
import RxRelay



class CKStore: CKStoreType {
    
    private let cdStack: CDStackType
    
    init(cdStack: CDStackType) {
        self.cdStack = cdStack
        self.onUpdate()
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(storeRemoteChange(_:)),
                         name: .NSPersistentStoreRemoteChange,
                         object: cdStack.persistentContainer.persistentStoreCoordinator)
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(containerEventChanged(_:)),
                         name: NSPersistentCloudKitContainer.eventChangedNotification,
                         object: cdStack.persistentContainer.persistentStoreCoordinator)
    }
    
    
    // MARK: - Interface
    private let _shareInfo = BehaviorRelay<[CKShareInfo]?>(value: nil)
    
    public lazy var shareInfo: Observable<[CKShareInfo]> = _shareInfo
        .compactMap({ $0 })
        .distinctUntilChanged()
        .share()
    
    
    // MARK: - Private Stuff
    @objc func storeRemoteChange(_ notification: Notification) {
        onUpdate()
    }

    @objc func containerEventChanged(_ notification: Notification) {
        onUpdate()
    }
    
    private func onUpdate() {
        updateShares({ [weak self] result in
            switch result {
            case .success(let shareInfo):
                self?._shareInfo.accept(shareInfo)
            case .failure(let error):
                assertionFailure("Something's wrong: \(error)")
            }
        })
    }
    
    private func updateShares(_ completion: @escaping (Result<[CKShareInfo], Error>) -> Void) {
        cdStack.saveContext.perform { [weak self] in
            let tripsQuery = CDTrip.fetchRequest()
            do {
                let cdTrips = try self?.cdStack.saveContext
                    .fetch(tripsQuery) ?? []
                let ckShares = try self?.cdStack.persistentContainer
                    .fetchShares(matching: cdTrips.map(\.objectID)) ?? [:]
                let shareInfos = cdTrips
                    .compactMap({ cdTrip -> CKShareInfo? in
                        guard let share = ckShares[cdTrip.objectID] else { return nil }
                        return CKShareInfo(
                            tripId: cdTrip.id,
                            role: share.currentUserParticipant?.editorRole,
                            members: share.participants
                                .filter { $0.userIdentity.userRecordID != share.currentUserParticipant?.userIdentity.userRecordID }
                                .map(\.member)
                        )
                    })
                DispatchQueue.main.async {
                    completion(.success(shareInfos))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
}
