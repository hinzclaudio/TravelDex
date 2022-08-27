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
    
    func clPlacemarks(for search: String) -> Observable<[CLPlacemark]> {
        Observable.create { observer in
            base.geocodeAddressString(search) { (placemarks, error) in
                if let error = error {
                    observer.onError(error)
                } else if let placemarks = placemarks {
                    observer.onNext(placemarks)
                    observer.onCompleted()
                } else {
                    assertionFailure("Something's missing...")
                    observer.onCompleted()
                }
            }
                
            return Disposables.create {
                base.cancelGeocode()
            }
        }
    }
    
    
    func clPlacemarks(for coordinate: Coordinate) -> Observable<[CLPlacemark]> {
        Observable.create { observer in
            let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            base.reverseGeocodeLocation(loc) { (placemarks, error) in
                if let error = error {
                    observer.onError(error)
                } else if let placemarks = placemarks {
                    observer.onNext(placemarks)
                    observer.onCompleted()
                } else {
                    assertionFailure("Something's missing...")
                    observer.onCompleted()
                }
            }
            
            return Disposables.create {
                base.cancelGeocode()
            }
        }
    }
    
}



extension Observable where Element == [CLPlacemark] {
    
    var asLocations: Observable<[Location]> {
        self
            .map { placemarks in
                placemarks
                    .filter { $0.location != nil }
                    .map { mark -> Location in
                        let regionString: String?
                        if let locality = mark.locality {
                            if let subLoc = mark.subLocality {
                                regionString = "\(locality), \(subLoc)"
                            } else{
                                regionString = locality
                            }
                        } else {
                            regionString = mark.subLocality
                        }
                        
                        return Location(
                            id: LocationID(),
                            name: mark.name ?? "",
                            region: regionString,
                            country: mark.country,
                            coordinate: Coordinate(
                                latitude: mark.location!.coordinate.latitude,
                                longitude: mark.location!.coordinate.longitude
                            ),
                            timezoneIdentifier: mark.timeZone?.identifier
                        )
                    }
            }
    }
    
}
