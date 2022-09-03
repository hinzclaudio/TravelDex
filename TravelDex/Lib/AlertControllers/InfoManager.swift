//
//  InfoManager.swift
//  TravelDex
//
//  Created by Claudio Hinz on 18.08.22.
//

import UIKit
import CoreLocation



class InfoManager {
    
    static func makeInfoController(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { _ in alert.dismiss(animated: true) }
            )
        )
        return alert
    }
    
    
    static func makeFallbackErrorController() -> UIAlertController {
        makeInfoController(title: "Error", message: "An unknown error occured.")
    }
    
    
    static func defaultErrorInfo(for error: Error) -> UIAlertController {
        if (error as NSError).code == CLError.Code.geocodeFoundNoResult.rawValue {
            return makeInfoController(title: "Error", message: "Your query did not produce any results.")
        } else {
            return makeFallbackErrorController()
        }
    }
    
}
