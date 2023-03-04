//
//  CKShareInfo.swift
//  TravelDex
//
//  Created by Claudio Hinz on 09.03.23.
//

import Foundation
import CloudKit



struct CKShareInfo: Equatable, WithAutoBuilder {
    // sourcery:begin: nonDefaultBuilderProperty
    let tripId: TripID
    let role: CKShareInfo.EditorRole?
    let members: [CKShareInfo.Member]
    // sourcery:end: nonDefaultBuilderProperty

// sourcery:inline:auto:CKShareInfo.AutoBuilderInit
    // MARK: - Init Buildable
    init(
        tripId: TripID, 
        role: CKShareInfo.EditorRole? = nil, 
        members: [CKShareInfo.Member]
    )
    {
        self.tripId = tripId
        self.role = role
        self.members = members
    }
    static var builder: CKShareInfoBuilder {
        CKShareInfoBuilder()
    }
    func cloneBuilder() -> CKShareInfoBuilder {
        CKShareInfo.builder
            .with(tripId: self.tripId)
            .with(role: self.role)
            .with(members: self.members)
    }
// sourcery:end
}
// sourcery:inline:after-auto:CKShareInfo.AutoBuilder-Builder
// MARK: - Builder
class CKShareInfoBuilder {


    private(set) var tripId: TripID?


    private(set) var role: CKShareInfo.EditorRole??


    private(set) var members: [CKShareInfo.Member]?

    func with(tripId: TripID) -> CKShareInfoBuilder {
        self.tripId = tripId; return self
    }
    func with(role: CKShareInfo.EditorRole?) -> CKShareInfoBuilder {
        self.role = role; return self
    }
    func with(members: [CKShareInfo.Member]) -> CKShareInfoBuilder {
        self.members = members; return self
    }
    func build() -> CKShareInfo? {
        guard
            let tripId = self.tripId,
            let role = self.role,
            let members = self.members
        else { return nil }
        return CKShareInfo(
            tripId: tripId,
            role: role,
            members: members
        )
    }
}
// sourcery:end
