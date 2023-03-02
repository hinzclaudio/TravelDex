//
//  CDMigrationVersion.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation
import CoreData



enum CDMigrationVersion: String, Equatable, CaseIterable {
    case version1 = "TravelDex"
    case version2 = "TravelDex 2"
    
    static var current: CDMigrationVersion {
        guard let latest = allCases.last else { fatalError("No versions available.") }
        return latest
    }
    
    var nextVersion: CDMigrationVersion? {
        switch self {
        case .version1:
            return .version2
        case .version2:
            return nil
        }
    }
}
