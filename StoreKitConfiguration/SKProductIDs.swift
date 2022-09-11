//
//  SKProductIDs.swift
//  TravelDex
//
//  Created by Claudio Hinz on 04.09.22.
//

import Foundation



enum SKProductIDs: String, CaseIterable {
    case premium = "de.hinzclaudio.TravelDex.premium"
    case premiumSupporter = "de.hinzclaudio.TravelDex.premiumSupporter"
    case premiumUltra = "de.hinzclaudio.TravelDex.premiumUltra"
    
    static var allPremiumIds: [String] {
        [
            SKProductIDs.premium,
            SKProductIDs.premiumSupporter,
            SKProductIDs.premiumUltra
        ]
            .map { $0.rawValue }
    }
    
}

