//
//  VerificationResultExt.swift
//  TravelDex
//
//  Created by Claudio Hinz on 04.09.22.
//

import Foundation
import StoreKit



extension VerificationResult {
    
    func isVerified() -> SignedType? {
        switch self {
        case .unverified:
            return nil
        case .verified(let signedType):
            return signedType
        }
    }
    
}
