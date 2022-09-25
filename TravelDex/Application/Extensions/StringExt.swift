//
//  StringExt.swift
//  TravelDex
//
//  Created by Claudio Hinz on 25.09.22.
//

import Foundation



extension String {
    
    var lettersOnly: String {
        let alphabetLowercased = "abcdefghijklmnopqrstuvwxyz"
        let alphabetUppercased = alphabetLowercased.uppercased()
        let digits = "0123456789"
        let allowedChars = alphabetLowercased + alphabetUppercased + digits
        return self
            .filter(allowedChars.contains(_:))
    }
    
}
