//
//  CKShareInfo.EditorRole.swift
//  TravelDex
//
//  Created by Claudio Hinz on 09.03.23.
//

import Foundation
import CloudKit



extension CKShareInfo {
    
    enum EditorRole: Int, Equatable, Comparable {
        case owner = 3
        case writeShare = 2
        case readShare = 1
        
        static func < (lhs: CKShareInfo.EditorRole, rhs: CKShareInfo.EditorRole) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
    
}



// MARK: - Helper Extension
extension CKShare.Participant {
    
    var editorRole: CKShareInfo.EditorRole? {
        if role == .owner {
            return .owner
        } else {
            switch self.permission {
            case .none, .unknown:
                return nil
            case .readOnly:
                return .readShare
            case .readWrite:
                return .writeShare
            @unknown default:
                return nil
            }
        }
    }
    
}
