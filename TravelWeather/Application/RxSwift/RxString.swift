//
//  RxString.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 06.08.22.
//

import Foundation
import RxSwift



extension Observable where Element == String? {
    
    var nilIfEmpty: Observable<String?> {
        map { str in
            if str?.isEmpty ?? true {
                return nil
            } else {
                return str
            }
        }
    }
    
}
