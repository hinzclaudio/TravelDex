//
//  RxGeocoder.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 14.08.22.
//

import Foundation
import CoreLocation
import RxSwift



extension Reactive where Base == CLGeocoder {
    
    func locations(for search: String) -> Observable<[CLPlacemark]> {
        Observable.create { observer in
            base.geocodeAddressString(search) { (placemarks, error) in
                if let error = error {
                    observer.onError(error)
                } else if let placemarks = placemarks {
                    observer.onNext(placemarks)
                    observer.onCompleted()
                } else {
                    assertionFailure("Something's missing...")
                }
            }
                
            return Disposables.create {
                base.cancelGeocode()
            }
        }
    }
    
}
