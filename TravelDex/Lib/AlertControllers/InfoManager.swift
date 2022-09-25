//
//  InfoManager.swift
//  TravelDex
//
//  Created by Claudio Hinz on 18.08.22.
//

import UIKit
import CoreLocation
import ZIPFoundation



class InfoManager {
    
    static func makeInfoController(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: Localizable.ok,
                style: .default,
                handler: { _ in alert.dismiss(animated: true) }
            )
        )
        return alert
    }
    
    
    static func makeFallbackErrorController() -> UIAlertController {
        makeInfoController(title: Localizable.errorTitle, message: Localizable.unknownErrorDescr)
    }
    
    static func makePremiumDisabledInfo() -> UIAlertController {
        makeInfoController(title: Localizable.premiumDisabledTitle, message: Localizable.premiumDisabledMsg)
    }
    
    static func makeDataCorruptedError() -> UIAlertController {
        makeInfoController(title: Localizable.errorTitle, message: Localizable.errorDataCorrupted)
    }
    
    static func makeAlreadyImportedError() -> UIAlertController {
        makeInfoController(title: Localizable.errorTitle, message: Localizable.errorAlreadyImported)
    }
    
    static func makeNumberOfPlacesExhaustedInfo() -> UIAlertController {
        makeInfoController(
            title: Localizable.premiumDisabledTitle,
            message: Localizable.premiumPlacesExhausted(SKNonPremiumConfiguration.maxLocationsPerTrip)
        )
    }
    
    
    static func defaultErrorInfo(for error: Error) -> UIAlertController {
        if (error as NSError).code == CLError.Code.geocodeFoundNoResult.rawValue {
            return makeInfoController(
                title: Localizable.errorTitle,
                message: Localizable.errorCannotMatchLocation
            )
        } else if (error as? PremiumStoreError) == .premiumFeaturesUnavailable {
            return makePremiumDisabledInfo()
        } else if let fileError = error as? FileManagementError {
            switch fileError {
            case .missingDirectory:
                return makeFallbackErrorController()
            case .unknown:
                return makeFallbackErrorController()
            case .dataCorrupted:
                return makeDataCorruptedError()
            case .alreadyImported:
                return makeAlreadyImportedError()
            }
        } else if let zipError = error as? Archive.ArchiveError {
            switch zipError {
            case .unreadableArchive:
                return makeDataCorruptedError()
            default:
                return makeFallbackErrorController()
            }
        } else {
            return makeFallbackErrorController()
        }
    }
    
}
