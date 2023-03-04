//
//  CKShareInfo.Member.swift
//  TravelDex
//
//  Created by Claudio Hinz on 09.03.23.
//

import Foundation
import CloudKit



extension CKShareInfo {
    
    struct Member: Equatable {
        let name: String?
        let email: String?
        let role: CKShareInfo.EditorRole?
        let status: CKShareInfo.AcceptanceState?
    }
    
}




// MARK: - Helper Extension
extension CKShare.Participant {
    
    var member: CKShareInfo.Member {
        let name: String?
        if let first = self.userIdentity.nameComponents?.givenName,
           let last = self.userIdentity.nameComponents?.familyName {
            name = first + " " + last
        } else if let first = self.userIdentity.nameComponents?.givenName {
            name = first
        } else {
            name = self.userIdentity.nameComponents?.familyName
        }
        
        let state: CKShareInfo.AcceptanceState?
        switch self.acceptanceStatus {
        case .unknown:
            state = nil
        case .removed:
            state = .removed
        case .pending:
            state = .pending
        case .accepted:
            state = .accepted
        @unknown default:
            state = nil
        }
            
        return CKShareInfo.Member(
            name: name,
            email: self.userIdentity.lookupInfo?.emailAddress,
            role: self.editorRole,
            status: state
        )
    }
    
}
