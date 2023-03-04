//
//  CKShareInfo.Status.swift
//  TravelDex
//
//  Created by Claudio Hinz on 09.03.23.
//

import Foundation



extension CKShareInfo {
    
    enum AcceptanceState: Equatable {
        case removed
        case pending
        case accepted
    }
    
}
